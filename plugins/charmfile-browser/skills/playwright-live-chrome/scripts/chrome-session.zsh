#!/bin/zsh

set -euo pipefail
export NO_UPDATE_NOTIFIER="${NO_UPDATE_NOTIFIER:-1}"

SESSION_NAME="${PLAYWRIGHT_LIVE_CHROME_SESSION:-chrome-live}"
EXTENSION_ID="mmlmfjhmonkocbjadbfplnigmagldckm"
CHROME_ROOT="$HOME/Library/Application Support/Google/Chrome"
KEYCHAIN_SERVICE="codex-playwright-extension"
EXTENSION_URL="https://chromewebstore.google.com/detail/playwright-extension/$EXTENSION_ID"

die() {
  print -u2 -- "$1"
  exit 1
}

require_cli() {
  [[ "$(uname -s)" == "Darwin" ]] || die "Charmfile live Chrome supports macOS only"
  command -v playwright-cli >/dev/null 2>&1 || die "playwright-cli is not installed or not on PATH"
  command -v jq >/dev/null 2>&1 || die "jq is required"
  command -v security >/dev/null 2>&1 || die "macOS security command is required"
}

extension_path() {
  find "$CHROME_ROOT" -maxdepth 4 -type d -path "*/Extensions/$EXTENSION_ID" -print -quit 2>/dev/null
}

session_json() {
  playwright-cli list --json
}

session_connected() {
  session_json | jq -e --arg session "$SESSION_NAME" '
    [.. | objects | select(.name? == $session or .session? == $session)] | length > 0
  ' >/dev/null
}

load_keychain_token() {
  if [[ -z "${PLAYWRIGHT_MCP_EXTENSION_TOKEN:-}" ]]; then
    local token
    token="$(security find-generic-password -a "$USER" -s "$KEYCHAIN_SERVICE" -w 2>/dev/null || true)"
    if [[ -n "$token" ]]; then
      export PLAYWRIGHT_MCP_EXTENSION_TOKEN="$token"
    fi
  fi
}

show_status() {
  local sessions extension token_configured connected
  sessions="$(session_json)"
  extension="$(extension_path)"
  token_configured=false
  connected=false
  security find-generic-password -a "$USER" -s "$KEYCHAIN_SERVICE" >/dev/null 2>&1 && token_configured=true
  print -r -- "$sessions" | jq -e --arg session "$SESSION_NAME" '
    [.. | objects | select(.name? == $session or .session? == $session)] | length > 0
  ' >/dev/null && connected=true

  jq -n \
    --arg cli_version "$(playwright-cli --version)" \
    --arg session "$SESSION_NAME" \
    --arg extension_path "$extension" \
    --argjson extension_installed "$([[ -n "$extension" ]] && print true || print false)" \
    --argjson keychain_token "$token_configured" \
    --argjson connected "$connected" \
    --argjson sessions "$sessions" \
    '{
      cliVersion: $cli_version,
      session: $session,
      connected: $connected,
      extensionInstalled: $extension_installed,
      extensionPath: (if $extension_path == "" then null else $extension_path end),
      keychainTokenConfigured: $keychain_token,
      sessions: $sessions.browsers
    }'
}

attach_extension() {
  local attach_output attach_rc token
  if session_connected; then
    show_status
    return
  fi
  [[ -n "$(extension_path)" ]] ||
    die "Playwright Extension is not installed. Use $EXTENSION_URL"
  load_keychain_token
  token="${PLAYWRIGHT_MCP_EXTENSION_TOKEN:-}"
  set +e
  attach_output="$(playwright-cli -s="$SESSION_NAME" attach --extension=chrome 2>&1)"
  attach_rc=$?
  set -e
  if [[ -n "$token" ]]; then
    attach_output="${attach_output//$token/[REDACTED]}"
  fi
  print -r -- "$attach_output"
  return "$attach_rc"
}

attach_cdp() {
  if session_connected; then
    show_status
    return
  fi
  exec playwright-cli -s="$SESSION_NAME" attach --cdp=chrome
}

detach_session() {
  if session_connected; then
    exec playwright-cli -s="$SESSION_NAME" detach
  fi
  print -- "Session $SESSION_NAME is not connected"
}

set_token() {
  local token
  read -r -s "token?Paste PLAYWRIGHT_MCP_EXTENSION_TOKEN: "
  print
  [[ -n "$token" ]] || die "No token provided"
  security add-generic-password -U -a "$USER" -s "$KEYCHAIN_SERVICE" -w "$token" >/dev/null
  unset token
  print -- "Playwright extension token stored in macOS Keychain"
}

clear_token() {
  security delete-generic-password -a "$USER" -s "$KEYCHAIN_SERVICE" >/dev/null 2>&1 || true
  print -- "Playwright extension token removed from macOS Keychain"
}

require_cli

case "${1:-status}" in
  status) show_status ;;
  attach) attach_extension ;;
  attach-cdp) attach_cdp ;;
  detach) detach_session ;;
  set-token) set_token ;;
  clear-token) clear_token ;;
  *) die "Usage: ${0:t} {status|attach|attach-cdp|detach|set-token|clear-token}" ;;
esac

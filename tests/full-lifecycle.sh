#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
lifecycle="$repo_root/scripts/install-charmfile"
extension_id="mmlmfjhmonkocbjadbfplnigmagldckm"

if ! command -v codex >/dev/null 2>&1; then
  printf '[note] Codex CLI unavailable; full lifecycle test skipped\n'
  exit 0
fi

test_root="$(mktemp -d)"
trap 'find "$test_root" -depth -delete' EXIT

setup_case() {
  local case_root="$1"
  local test_home="$case_root/home"
  local chrome_root="$test_home/Library/Application Support/Google/Chrome"
  local chrome_app="$case_root/Google Chrome.app"
  mkdir -p \
    "$test_home/.local/bin" \
    "$chrome_root/Default/Extensions/$extension_id" \
    "$chrome_app"
  cat > "$test_home/.local/bin/playwright-cli" <<'EOF'
#!/bin/sh
case "${1:-}" in
  --version)
    printf '0.1.17\n'
    ;;
  --help)
    printf 'Commands: snapshot install-browser attach list\n'
    ;;
  install-browser)
    if [ "${2:-}" = "--list" ]; then
      printf '  /test/cache/chromium-1234\n'
    fi
    ;;
  *)
    exit 0
    ;;
esac
EOF
  chmod 755 "$test_home/.local/bin/playwright-cli"
  cat > "$test_home/.local/bin/obsidian-sidecar" <<'EOF'
#!/bin/sh
score="${CHARMFILE_TEST_SIDECAR_SCORE:-95}"
printf '{"critical_failures":0,"score":%s,"basic_memory":"ok"}\n' "$score"
EOF
  chmod 755 "$test_home/.local/bin/obsidian-sidecar"
}

case_command() {
  local case_root="$1"
  shift
  local test_home="$case_root/home"
  HOME="$test_home" \
    CODEX_HOME="$test_home/.codex" \
    CHARMFILE_TARGET_HOME="$test_home" \
    CHARMFILE_CHROME_APP="$case_root/Google Chrome.app" \
    CHARMFILE_CHROME_ROOT="$test_home/Library/Application Support/Google/Chrome" \
    PATH="$test_home/.local/bin:$PATH" \
    "$@"
}

installed_count() {
  local case_root="$1"
  case_command "$case_root" codex plugin list --json |
    jq '[.installed[] | select(.pluginId | endswith("@charmfile")) | select(.installed == true)] | length'
}

assert_plugin_state() {
  local case_root="$1"
  local plugin_name="$2"
  local expected="$3"
  local actual
  actual="$({
    case_command "$case_root" codex plugin list --json |
      jq -r --arg id "$plugin_name@charmfile" '
        any(.installed[];
          .pluginId == $id and .installed == true and .enabled == true
        )
      '
  })"
  [ "$actual" = "$expected" ]
}

run_case() {
  local label="$1"
  local expected_count="$2"
  local expect_memory="$3"
  local expect_browser="$4"
  shift 4
  local case_root="$test_root/$label"
  local test_home="$case_root/home"
  setup_case "$case_root"

  case_command "$case_root" \
    "$lifecycle" plan "$@" > "$case_root/plan.txt"
  grep -Fq 'Charmfile install plan' "$case_root/plan.txt"
  grep -Fq 'charmfile-core' "$case_root/plan.txt"
  if [ "$expect_memory" = "true" ]; then
    grep -Fq 'charmfile-memory' "$case_root/plan.txt"
  fi
  if [ "$expect_browser" = "true" ]; then
    grep -Fq 'charmfile-browser' "$case_root/plan.txt"
    grep -Fq 'keep-compatible-unmanaged' "$case_root/plan.txt"
  else
    grep -Fq 'browser automation: not selected' "$case_root/plan.txt"
  fi

  if case_command "$case_root" \
    "$lifecycle" install "$@" \
      > "$case_root/unapproved.txt" 2>&1; then
    printf 'unapproved %s install unexpectedly succeeded\n' "$label" >&2
    exit 1
  fi

  case_command "$case_root" \
    "$lifecycle" install "$@" --yes \
      > "$case_root/install.txt"
  grep -Fq 'Charmfile result: healthy' "$case_root/install.txt"
  [ "$(installed_count "$case_root")" -eq "$expected_count" ]
  assert_plugin_state "$case_root" charmfile-core true
  assert_plugin_state "$case_root" charmfile-memory "$expect_memory"
  assert_plugin_state "$case_root" charmfile-browser "$expect_browser"
  test -d "$test_home/.codex"
  test -f "$test_home/.codex/AGENTS.md"
  test -f "$test_home/.codex/charmfile.config.toml"
  test -f "$test_home/.zprofile"
  grep -Fq '# CHARMFILE:PATH:START' "$test_home/.zprofile"
  test -x "$test_home/.local/bin/charmfile"
  test -x "$test_home/.local/bin/charmfile-codex"
  test -x "$test_home/.local/bin/codex-secrets"

  case_command "$case_root" \
    "$test_home/.local/bin/charmfile" doctor \
      > "$case_root/launcher-doctor.txt"
  grep -Fq 'Charmfile result: healthy' "$case_root/launcher-doctor.txt"

  case_command "$case_root" \
    "$test_home/.local/bin/charmfile" status --repo "$case_root" \
      > "$case_root/launcher-status.txt"
  grep -Fq 'Charmfile status' "$case_root/launcher-status.txt"
  grep -Fq 'Core: installed' "$case_root/launcher-status.txt"
  grep -Fq 'Read-only: no configuration, plugins, or memory were changed.' \
    "$case_root/launcher-status.txt"

  if [ "$expect_browser" = "true" ]; then
    case_command "$case_root" \
      "$test_home/.local/bin/charmfile" doctor --require-live-chrome \
        > "$case_root/live-browser-doctor.txt"
    grep -Fq 'Charmfile result: healthy' "$case_root/live-browser-doctor.txt"
  elif case_command "$case_root" \
    "$test_home/.local/bin/charmfile" doctor --require-live-chrome \
      > "$case_root/missing-browser.txt" 2>&1; then
    printf '%s doctor accepted required live Chrome without the browser pack\n' \
      "$label" >&2
    exit 1
  fi

  case_command "$case_root" \
    "$lifecycle" update --yes > "$case_root/update.txt"
  grep -Fq 'preserve currently installed Charmfile packs' "$case_root/update.txt"
  grep -Fq 'Local marketplace: using the current checkout' "$case_root/update.txt"
  grep -Fq 'Charmfile result: healthy' "$case_root/update.txt"
  grep -Fq 'Post-update result: healthy' "$case_root/update.txt"
  grep -Fq 'Charmfile Memory engine: Sidecar score 95' "$case_root/update.txt"
  [ "$(installed_count "$case_root")" -eq "$expected_count" ]

  if case_command "$case_root" \
    "$lifecycle" update --preset full --yes \
      > "$case_root/update-selection.txt" 2>&1; then
    printf '%s update unexpectedly accepted a selection override\n' "$label" >&2
    exit 1
  fi
}

run_case standard 2 true false
run_case core 1 false false --preset core
run_case research 3 true false --with research
run_case browser 3 true true --with-browser
run_case full 8 true true --preset full

standard_root="$test_root/standard"
standard_home="$standard_root/home"
case_command "$standard_root" \
  "$standard_home/.local/bin/charmfile-codex" --version \
    > "$standard_root/profile-version.txt"
grep -Fq 'codex-cli' "$standard_root/profile-version.txt"

if CHARMFILE_TEST_SIDECAR_SCORE=79 \
  case_command "$standard_root" \
    "$standard_home/.local/bin/charmfile" doctor --after-update \
      > "$standard_root/unhealthy-sidecar.txt" 2>&1; then
  printf 'post-update doctor accepted an unhealthy Sidecar score\n' >&2
  exit 1
fi
grep -Fq 'Obsidian Sidecar health gate failed' \
  "$standard_root/unhealthy-sidecar.txt"

if case_command "$standard_root" \
  "$lifecycle" plan --with does-not-exist \
    > "$standard_root/unknown-pack.txt" 2>&1; then
  printf 'plan unexpectedly accepted an unknown pack\n' >&2
  exit 1
fi
grep -Fq 'selected pack is not in this marketplace' \
  "$standard_root/unknown-pack.txt"

printf '[ok] core, standard, individual, browser, and full selections; approval; selected-pack doctor; update preservation; profile; and Sidecar health gate\n'

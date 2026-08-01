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
test_home="$test_root/home"
chrome_root="$test_home/Library/Application Support/Google/Chrome"
chrome_app="$test_root/Google Chrome.app"
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

export HOME="$test_home"
export CODEX_HOME="$test_home/.codex"
export CHARMFILE_TARGET_HOME="$test_home"
export CHARMFILE_CHROME_APP="$chrome_app"
export CHARMFILE_CHROME_ROOT="$chrome_root"
export PATH="$test_home/.local/bin:$PATH"

"$lifecycle" plan > "$test_root/plan.txt"
grep -Fq 'charmfile-browser' "$test_root/plan.txt"
grep -Fq 'keep-compatible-unmanaged' "$test_root/plan.txt"

if "$lifecycle" install > "$test_root/unapproved.txt" 2>&1; then
  printf 'unapproved full install unexpectedly succeeded\n' >&2
  exit 1
fi

"$lifecycle" install --yes > "$test_root/install.txt"
grep -Fq 'Full result: healthy' "$test_root/install.txt"
test -d "$test_home/.codex"
test -f "$test_home/.codex/AGENTS.md"
test -f "$test_home/.codex/charmfile.config.toml"
test -f "$test_home/.zprofile"
grep -Fq '# CHARMFILE:PATH:START' "$test_home/.zprofile"
test -x "$test_home/.local/bin/charmfile"
test -x "$test_home/.local/bin/charmfile-codex"
test -x "$test_home/.local/bin/codex-secrets"
"$test_home/.local/bin/charmfile" doctor \
  --require-live-chrome > "$test_root/launcher-doctor.txt"
grep -Fq 'Full result: healthy' "$test_root/launcher-doctor.txt"
"$test_home/.local/bin/charmfile-codex" --version \
  > "$test_root/profile-version.txt"
grep -Fq 'codex-cli' "$test_root/profile-version.txt"

"$lifecycle" update --yes > "$test_root/update.txt"
grep -Fq 'Local marketplace: using the current checkout' \
  "$test_root/update.txt"
grep -Fq 'Full result: healthy' "$test_root/update.txt"
grep -Fq 'Post-update result: healthy' "$test_root/update.txt"
grep -Fq 'Optional Obsidian Sidecar: score 95' "$test_root/update.txt"

if CHARMFILE_TEST_SIDECAR_SCORE=79 \
  "$test_home/.local/bin/charmfile" doctor --after-update \
    > "$test_root/unhealthy-sidecar.txt" 2>&1; then
  printf 'post-update doctor accepted an unhealthy Sidecar score\n' >&2
  exit 1
fi
grep -Fq 'Obsidian Sidecar health gate failed' \
  "$test_root/unhealthy-sidecar.txt"

printf '[ok] full macOS plan, approval, eight-pack install, profile, Playwright preservation, launcher, doctor, and local update\n'

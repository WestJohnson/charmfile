#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
extension_id="mmlmfjhmonkocbjadbfplnigmagldckm"

if ! command -v codex >/dev/null 2>&1; then
  printf '[note] Codex CLI unavailable; rc.5 update test skipped\n'
  exit 0
fi

test_root="$(mktemp -d)"
trap 'find "$test_root" -depth -delete' EXIT
source_root="$test_root/source"
test_home="$test_root/home"
chrome_root="$test_home/Library/Application Support/Google/Chrome"
chrome_app="$test_root/Google Chrome.app"
release_commit="$(git -C "$repo_root" rev-parse HEAD)"

git clone --quiet --no-hardlinks "$repo_root" "$source_root"
git -C "$source_root" checkout --quiet v0.1.0-rc.5
mkdir -p \
  "$test_home/.local/bin" \
  "$chrome_root/Default/Extensions/$extension_id" \
  "$chrome_app"

cat > "$test_home/.local/bin/playwright-cli" <<'EOF'
#!/bin/sh
case "${1:-}" in
  --version) printf '0.1.17\n' ;;
  --help) printf 'Commands: snapshot install-browser attach list\n' ;;
  install-browser)
    if [ "${2:-}" = "--list" ]; then
      printf '  /test/cache/chromium-1234\n'
    fi
    ;;
  *) exit 0 ;;
esac
EOF
chmod 755 "$test_home/.local/bin/playwright-cli"
cat > "$test_home/.local/bin/obsidian-sidecar" <<'EOF'
#!/bin/sh
printf '{"critical_failures":0,"score":95,"basic_memory":"ok"}\n'
EOF
chmod 755 "$test_home/.local/bin/obsidian-sidecar"

export HOME="$test_home"
export CODEX_HOME="$test_home/.codex"
export CHARMFILE_TARGET_HOME="$test_home"
export CHARMFILE_CHROME_APP="$chrome_app"
export CHARMFILE_CHROME_ROOT="$chrome_root"
export PATH="$test_home/.local/bin:$PATH"

"$source_root/scripts/install-charmfile" install --yes \
  > "$test_root/rc5-install.txt"
rc5_count="$(
  codex plugin list --json |
    jq '[.installed[] | select(.pluginId | endswith("@charmfile")) | select(.installed == true)] | length'
)"
[ "$rc5_count" -eq 8 ]

git -C "$source_root" checkout --quiet "$release_commit"
"$test_home/.local/bin/charmfile" update --yes \
  > "$test_root/rc6-update.txt"
grep -Fq 'preserve currently installed Charmfile packs' \
  "$test_root/rc6-update.txt"
grep -Fq 'Post-update result: healthy' "$test_root/rc6-update.txt"

rc6_plugins="$(codex plugin list --json)"
rc6_count="$(
  printf '%s\n' "$rc6_plugins" |
    jq '[.installed[] | select(.pluginId | endswith("@charmfile")) | select(.installed == true)] | length'
)"
[ "$rc6_count" -eq 8 ]
printf '%s\n' "$rc6_plugins" |
  jq -e '
    [.installed[]
      | select(.pluginId | endswith("@charmfile"))
      | select(.installed == true and .enabled == true)
      | .version == "0.1.0-rc.6"
    ]
    | length == 8 and all
  ' >/dev/null

printf '[ok] rc.5 full installation preserves all eight packs during rc.6 update\n'

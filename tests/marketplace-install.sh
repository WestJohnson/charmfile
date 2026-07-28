#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

if ! command -v codex >/dev/null 2>&1; then
  printf '[note] Codex CLI unavailable; isolated marketplace install test skipped\n'
  exit 0
fi

test_codex_root="$(mktemp -d)"
trap 'find "$test_codex_root" -depth -delete' EXIT

CODEX_HOME="$test_codex_root" \
  codex plugin marketplace add "$repo_root" --json \
  > "$test_codex_root/marketplace-add.json"
grep -Fq '"marketplaceName": "charmfile"' \
  "$test_codex_root/marketplace-add.json"

plugins=(
  charmfile-core
  charmfile-memory
  charmfile-frontend
  charmfile-marketing
  charmfile-research
  charmfile-infrastructure
  charmfile-threejs
)

for plugin_name in "${plugins[@]}"; do
  CODEX_HOME="$test_codex_root" \
    codex plugin add "$plugin_name@charmfile" --json \
    > "$test_codex_root/$plugin_name.json"
  grep -Fq "\"pluginId\": \"$plugin_name@charmfile\"" \
    "$test_codex_root/$plugin_name.json"
  grep -Fq '"version": "0.1.0-rc.1"' "$test_codex_root/$plugin_name.json"
done

CODEX_HOME="$test_codex_root" codex plugin list \
  > "$test_codex_root/plugin-list.txt"
installed_count="$(
  grep -c 'installed, enabled' "$test_codex_root/plugin-list.txt" || true
)"
[ "$installed_count" -eq "${#plugins[@]}" ]

printf '[ok] isolated Codex marketplace install: %s plugins\n' "$installed_count"

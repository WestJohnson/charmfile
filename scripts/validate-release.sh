#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

python3 "$repo_root/scripts/validate.py"

bash -n "$repo_root/scripts/charmfile"
bash -n "$repo_root/scripts/install-charmfile"
bash -n "$repo_root/scripts/validate-release.sh"
bash -n "$repo_root/scripts/build-release.sh"
bash -n "$repo_root/tests/core-install.sh"
bash -n "$repo_root/tests/browser-setup.sh"
bash -n "$repo_root/tests/full-lifecycle.sh"
bash -n "$repo_root/tests/marketplace-install.sh"
bash -n "$repo_root/tests/secrets-helper.sh"
bash -n "$repo_root/plugins/charmfile-core/skills/charmfile-setup/scripts/charmfile"
bash -n "$repo_root/plugins/charmfile-core/skills/charmfile-setup/scripts/codex-secrets"
bash -n "$repo_root/plugins/charmfile-browser/skills/browser-setup/scripts/charmfile-browser"
sh -n "$repo_root/plugins/charmfile-browser/skills/browser-setup/scripts/playwright-cli-wrapper"
zsh -n "$repo_root/plugins/charmfile-browser/skills/playwright-live-chrome/scripts/chrome-session.zsh"
sh -n "$repo_root/plugins/charmfile-core/skills/charmfile-setup/assets/charmfile-codex"
sh -n "$repo_root/plugins/charmfile-core/skills/charmfile-setup/assets/charmfile-launcher"
sh -n "$repo_root/plugins/charmfile-core/skills/charmfile-setup/assets/zprofile.block.sh"
python3 -m py_compile \
  "$repo_root/scripts/validate.py" \
  "$repo_root/plugins/charmfile-marketing/skills/dataforseo-api/scripts/dfs.py"

"$repo_root/tests/core-install.sh"
"$repo_root/tests/browser-setup.sh"
"$repo_root/tests/marketplace-install.sh"
"$repo_root/tests/secrets-helper.sh"
"$repo_root/tests/full-lifecycle.sh"
python3 \
  "$repo_root/plugins/charmfile-marketing/skills/dataforseo-api/scripts/dfs.py" \
  --help >/dev/null

plugin_validator="${CHARMFILE_PLUGIN_VALIDATOR:-$HOME/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py}"
skill_validator="${CHARMFILE_SKILL_VALIDATOR:-$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py}"

validator_python=(python3)
if [ -f "$plugin_validator" ] || [ -f "$skill_validator" ]; then
  if ! python3 -c 'import yaml' >/dev/null 2>&1; then
    if command -v uv >/dev/null 2>&1; then
      validator_python=(uv run --quiet --with pyyaml python)
    else
      printf '[fail] official validators require PyYAML; install PyYAML or uv\n' >&2
      exit 1
    fi
  fi
fi

if [ -f "$plugin_validator" ]; then
  for plugin_dir in "$repo_root"/plugins/*; do
    "${validator_python[@]}" "$plugin_validator" "$plugin_dir"
  done
else
  printf '[note] official plugin validator not found; repository validator completed\n'
fi

if [ -f "$skill_validator" ]; then
  while IFS= read -r skill_file; do
    "${validator_python[@]}" "$skill_validator" "$(dirname "$skill_file")"
  done < <(
    find \
      "$repo_root/plugins" \
      "$repo_root/.agents/skills" \
      -path '*/skills/*/SKILL.md' \
      -print |
      sort
  )
else
  printf '[note] official skill validator not found; repository validator completed\n'
fi

printf '[ok] Charmfile release validation passed\n'

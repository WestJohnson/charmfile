#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
charmfile="$repo_root/scripts/charmfile"

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

test_home="$test_root/home"
test_bin="$test_root/bin"
test_repo="$test_root/repository"
test_new_repo="$test_root/new-repository"
test_inverted_repo="$test_root/inverted-repository"
test_duplicate_repo="$test_root/duplicate-repository"
mkdir -p \
  "$test_home" \
  "$test_bin" \
  "$test_repo" \
  "$test_new_repo" \
  "$test_inverted_repo" \
  "$test_duplicate_repo"

printf '#!/usr/bin/env sh\nexit 0\n' > "$test_bin/codex"
chmod 755 "$test_bin/codex"
export PATH="$test_bin:$PATH"
export CHARMFILE_TARGET_HOME="$test_home"

"$charmfile" plan --scope user > "$test_root/plan.txt"
grep -Fq 'guidance action: create' "$test_root/plan.txt"

if "$charmfile" install --scope user > "$test_root/unapproved.txt" 2>&1; then
  printf 'unapproved install unexpectedly succeeded\n' >&2
  exit 1
fi

"$charmfile" install --scope user --yes > "$test_root/install.txt"
guidance="$test_home/.codex/AGENTS.md"
test -f "$guidance"
test "$(grep -Fxc '<!-- CHARMFILE:START -->' "$guidance")" -eq 1
test "$(grep -Fxc '<!-- CHARMFILE:END -->' "$guidance")" -eq 1

guidance_temp="$test_root/guidance-modified.md"
sed \
  's/Keep the primary agent as the operator/Keep an outdated agent as the operator/' \
  "$guidance" > "$guidance_temp"
{
  printf '# User-owned footer\n'
  sed -n '1,$p' "$guidance_temp"
} > "$guidance"

"$charmfile" install --scope user --yes > "$test_root/update.txt"
grep -Fq '# User-owned footer' "$guidance"
grep -Fq 'Keep the primary agent as the operator' "$guidance"
test "$(find "$test_home/.codex" -maxdepth 1 -name 'AGENTS.md.backup.*' | wc -l | tr -d ' ')" -ge 1
"$charmfile" doctor --scope user > "$test_root/doctor.txt"
grep -Fq 'Result: healthy' "$test_root/doctor.txt"

printf '%s\n' \
  '# User-owned base config' \
  'model = "user-owned-model"' > "$test_home/.codex/config.toml"
printf '# User-owned shell setup\n' > "$test_home/.zprofile"
cp "$test_home/.codex/config.toml" "$test_root/config-before.toml"
"$charmfile" plan \
  --scope user \
  --with-path \
  --with-profile > "$test_root/profile-plan.txt"
grep -Fq 'portable profile: create' "$test_root/profile-plan.txt"
grep -Fq 'shell PATH block: append' "$test_root/profile-plan.txt"
"$charmfile" install \
  --scope user \
  --with-path \
  --with-profile \
  --yes > "$test_root/profile-install.txt"
cmp -s "$test_root/config-before.toml" "$test_home/.codex/config.toml"
grep -Fq '# User-owned shell setup' "$test_home/.zprofile"
grep -Fq '# CHARMFILE:PATH:START' "$test_home/.zprofile"
test "$(
  find "$test_home" -maxdepth 1 -name '.zprofile.backup.*' |
    wc -l |
    tr -d ' '
)" -ge 1
profile="$test_home/.codex/charmfile.config.toml"
test -f "$profile"
grep -Fq 'approval_policy = "on-request"' "$profile"
grep -Fq 'sandbox_mode = "workspace-write"' "$profile"
grep -Fq 'personality = "pragmatic"' "$profile"
grep -Fq '"git-branch"' "$profile"
grep -Fq 'goals = true' "$profile"
grep -Fq 'multi_agent = true' "$profile"
grep -Fq 'plugins = true' "$profile"
grep -Fq 'unified_exec = true' "$profile"
grep -Fq '[mcp_servers.openaiDeveloperDocs]' "$profile"
if grep -Eq 'danger-full-access|approval_policy = "never"|model = ' "$profile"; then
  printf 'portable profile contains a non-portable or unsafe value\n' >&2
  exit 1
fi
test -x "$test_home/.local/bin/charmfile"
test -x "$test_home/.local/bin/charmfile-codex"
"$charmfile" doctor \
  --scope user \
  --with-path \
  --with-profile > "$test_root/profile-doctor.txt"
grep -Fq 'Portable profile loads in Codex' \
  "$test_root/profile-doctor.txt"

cp "$test_home/.zprofile" "$test_root/zprofile-valid"
printf '%s\n' \
  '# User-owned shell setup' \
  '# CHARMFILE:PATH:END' \
  '# CHARMFILE:PATH:START' > "$test_home/.zprofile"
cp "$test_home/.zprofile" "$test_root/zprofile-inverted"
if "$charmfile" plan \
  --scope user \
  --with-path > "$test_root/path-inverted-plan.txt" 2>&1; then
  printf 'plan unexpectedly accepted inverted PATH markers\n' >&2
  exit 1
fi
grep -Fq 'shell PATH block: blocked-invalid-markers' \
  "$test_root/path-inverted-plan.txt"
cmp -s "$test_root/zprofile-inverted" "$test_home/.zprofile"
cp "$test_root/zprofile-valid" "$test_home/.zprofile"

printf '# Existing repository guidance\n' > "$test_repo/AGENTS.md"
"$charmfile" install --scope repo --repo "$test_repo" --yes > "$test_root/repo-install.txt"
grep -Fq '# Existing repository guidance' "$test_repo/AGENTS.md"
test "$(grep -Fxc '<!-- CHARMFILE:START -->' "$test_repo/AGENTS.md")" -eq 1
"$charmfile" doctor --scope repo --repo "$test_repo" > "$test_root/repo-doctor.txt"

"$charmfile" install --scope repo --repo "$test_new_repo" --yes > "$test_root/new-repo-install.txt"
grep -Fq '# Repository Agent Guidance' "$test_new_repo/AGENTS.md"

printf '%s\n' \
  '# Existing repository guidance' \
  '<!-- CHARMFILE:END -->' \
  'leave this untouched' \
  '<!-- CHARMFILE:START -->' > "$test_inverted_repo/AGENTS.md"
cp "$test_inverted_repo/AGENTS.md" "$test_root/inverted-before.md"
if "$charmfile" plan --scope repo --repo "$test_inverted_repo" > "$test_root/inverted-plan.txt" 2>&1; then
  printf 'plan unexpectedly accepted inverted markers\n' >&2
  exit 1
fi
grep -Fq 'guidance action: blocked-invalid-markers' "$test_root/inverted-plan.txt"
if "$charmfile" install --scope repo --repo "$test_inverted_repo" --yes > "$test_root/inverted-install.txt" 2>&1; then
  printf 'install unexpectedly accepted inverted markers\n' >&2
  exit 1
fi
cmp -s "$test_root/inverted-before.md" "$test_inverted_repo/AGENTS.md"

printf '%s\n' \
  '# Existing repository guidance' \
  '<!-- CHARMFILE:START -->' \
  'first block' \
  '<!-- CHARMFILE:END -->' \
  '<!-- CHARMFILE:START -->' \
  'second block' \
  '<!-- CHARMFILE:END -->' > "$test_duplicate_repo/AGENTS.md"
if "$charmfile" install --scope repo --repo "$test_duplicate_repo" --yes > "$test_root/duplicate-install.txt" 2>&1; then
  printf 'install unexpectedly accepted duplicate markers\n' >&2
  exit 1
fi

printf '[ok] core install, portable profile, approval, safe updates, backups, marker rejection, preservation, and doctor\n'

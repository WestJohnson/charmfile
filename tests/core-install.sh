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

printf '[ok] core install, approval, scoped headings, safe updates, backups, marker rejection, preservation, and doctor\n'

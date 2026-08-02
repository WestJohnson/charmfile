#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
lifecycle="$repo_root/scripts/install-charmfile"

test_root="$(mktemp -d)"
trap 'find "$test_root" -depth -delete' EXIT

fail() {
  printf '[fail] %s\n' "$*" >&2
  exit 1
}

assert_contains() {
  local expected="$1"
  local path="$2"
  grep -Fq "$expected" "$path" ||
    fail "expected '$expected' in $path"
}

assert_not_contains() {
  local unexpected="$1"
  local path="$2"
  if grep -Fq "$unexpected" "$path"; then
    fail "unexpected '$unexpected' in $path"
  fi
}

test_home="$test_root/home"
test_bin="$test_root/bin"
project_root="$test_root/example-project"
uninitialized_root="$test_root/uninitialized"
vault_root="$test_home/vault"
config_path="$test_home/.config/codex-obsidian-sidecar/config.json"
health_path="$test_home/.local/share/codex-obsidian-sidecar/health.json"
note_path="$vault_root/10 Projects/example-project/Project.md"

mkdir -p \
  "$test_bin" \
  "$project_root" \
  "$uninitialized_root" \
  "$(dirname "$config_path")" \
  "$(dirname "$health_path")" \
  "$(dirname "$note_path")"

cat > "$test_bin/codex" <<'EOF'
#!/bin/sh
if [ "${1:-}" = "plugin" ] && [ "${2:-}" = "list" ] &&
  [ "${3:-}" = "--json" ]; then
  printf '%s\n' '{"installed":[{"pluginId":"charmfile-core@charmfile","installed":true},{"pluginId":"charmfile-memory@charmfile","installed":true}]}'
  exit 0
fi
exit 1
EOF
chmod 755 "$test_bin/codex"

cat > "$test_bin/obsidian-sidecar" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod 755 "$test_bin/obsidian-sidecar"

git -C "$project_root" init -q
git -C "$project_root" config user.email test@example.com
git -C "$project_root" config user.name 'Charmfile Test'
printf '# Example\n' > "$project_root/README.md"
git -C "$project_root" add README.md
git -C "$project_root" commit -qm initial

run_charmfile() {
  CHARMFILE_TARGET_HOME="$test_home" \
    PATH="$test_bin:$PATH" \
    "$lifecycle" "$@"
}

run_charmfile init \
  --repo "$project_root" \
  --id example-project \
  --name 'Example Project' \
  --repository 'https://reader@example.com/team/example.git?ref=main' \
  > "$test_root/init-plan.txt"

manifest="$project_root/.charmfile/project.toml"
[ ! -e "$manifest" ] || fail 'init plan wrote a manifest without approval'
assert_contains 'action: create' "$test_root/init-plan.txt"
assert_contains 'secrets and machine paths: excluded' "$test_root/init-plan.txt"
assert_contains 'https://example.com/team/example.git' "$test_root/init-plan.txt"
assert_not_contains 'reader@' "$test_root/init-plan.txt"
assert_not_contains '?ref=main' "$test_root/init-plan.txt"

run_charmfile init \
  --repo "$project_root" \
  --id example-project \
  --name 'Example Project' \
  --repository 'https://reader@example.com/team/example.git?ref=main' \
  --yes > "$test_root/init-apply.txt"

[ -f "$manifest" ] && [ ! -L "$manifest" ] ||
  fail 'approved init did not create a regular manifest'
[ "$(stat -f '%Lp' "$manifest")" = '644' ] ||
  fail 'manifest permissions are not 0644'
assert_contains 'schema = 1' "$manifest"
assert_contains 'managed_by = "charmfile"' "$manifest"
assert_contains 'id = "example-project"' "$manifest"
assert_contains 'canonical_id = "project:example-project"' "$manifest"
assert_contains 'canonical = "https://example.com/team/example.git"' "$manifest"
assert_contains 'project = "codex-vault"' "$manifest"
assert_contains 'path = "10 Projects/example-project/Project.md"' "$manifest"
assert_contains 'uri = "memory://codex-vault/10-projects/example-project/project"' "$manifest"
assert_not_contains "$test_root" "$manifest"

run_charmfile init \
  --repo "$project_root" \
  --id example-project \
  --name 'Example Project' \
  --repository 'https://example.com/team/example.git' \
  --yes > "$test_root/init-current.txt"
assert_contains 'action: current' "$test_root/init-current.txt"
assert_contains 'Project manifest is already current' "$test_root/init-current.txt"

cp "$manifest" "$test_root/manifest-good.toml"
printf '\n# user-owned difference\n' >> "$manifest"
before_blocked="$(shasum -a 256 "$manifest" | awk '{print $1}')"
if run_charmfile init \
  --repo "$project_root" \
  --id example-project \
  --name 'Example Project' \
  --repository 'https://example.com/team/example.git' \
  --yes > "$test_root/init-blocked.txt" 2>&1; then
  fail 'init overwrote a differing existing manifest'
fi
after_blocked="$(shasum -a 256 "$manifest" | awk '{print $1}')"
[ "$before_blocked" = "$after_blocked" ] ||
  fail 'blocked init changed the existing manifest'
assert_contains 'action: blocked-existing' "$test_root/init-blocked.txt"
cp "$test_root/manifest-good.toml" "$manifest"

cat > "$config_path" <<EOF
{
  "vault_path": "$vault_root",
  "basic_memory_project": "codex-vault"
}
EOF

cat > "$health_path" <<'EOF'
{
  "checked_at": "2026-08-01T10:00:00+00:00",
  "score": 95,
  "critical_failures": 0,
  "basic_memory": "ok"
}
EOF

cat > "$note_path" <<'EOF'
---
title: Example Project
freshness:
  observed_at: '2026-08-01T09:00:00+00:00'
  review_after: '2099-08-01T09:00:00+00:00'
---

<!-- SIDECAR:CURRENT-STATE:START -->
- **Phase:** Building the first portable continuity contract
- **Latest outcome:** The project identity is now explicit and local-first.
- **Resume:** Verify the Resume Kit against the release lifecycle.
<!-- SIDECAR:CURRENT-STATE:END -->

<!-- SIDECAR:OPEN-WORK:START -->
1. Add lifecycle regression coverage. ([[Sessions/example|source]])
2. Document unavailable-state behavior.
<!-- SIDECAR:OPEN-WORK:END -->

<!-- SIDECAR:DECISION-REVIEW:START -->
- Portable identity remains repository-owned; status `proposed`.
- Cloud checks stay explicit; status `accepted`.
<!-- SIDECAR:DECISION-REVIEW:END -->
EOF

manifest_before="$(shasum -a 256 "$manifest" | awk '{print $1}')"
note_before="$(shasum -a 256 "$note_path" | awk '{print $1}')"
config_before="$(shasum -a 256 "$config_path" | awk '{print $1}')"
health_before="$(shasum -a 256 "$health_path" | awk '{print $1}')"

run_charmfile resume --repo "$project_root" > "$test_root/resume.txt"
assert_contains 'Name: Example Project' "$test_root/resume.txt"
assert_contains 'Identity: project:example-project' "$test_root/resume.txt"
assert_contains 'Git: main at' "$test_root/resume.txt"
assert_contains 'Phase: Building the first portable continuity contract' "$test_root/resume.txt"
assert_contains 'Latest outcome: The project identity is now explicit and local-first.' "$test_root/resume.txt"
assert_contains 'Resume: Verify the Resume Kit against the release lifecycle.' "$test_root/resume.txt"
assert_contains 'Freshness: current' "$test_root/resume.txt"
assert_contains 'Decisions: 1 proposed for optional review' "$test_root/resume.txt"
assert_contains '1. Add lifecycle regression coverage.' "$test_root/resume.txt"
assert_not_contains 'Sessions/example' "$test_root/resume.txt"
assert_contains 'Read-only: no configuration or memory was changed.' "$test_root/resume.txt"

run_charmfile status --repo "$project_root" > "$test_root/status.txt"
assert_contains 'Identity: project:example-project · Example Project' "$test_root/status.txt"
assert_contains 'Core: installed' "$test_root/status.txt"
assert_contains 'Memory: healthy · cached score 95 · Basic Memory ok' "$test_root/status.txt"
assert_contains 'Cloud: not configured' "$test_root/status.txt"
assert_contains 'Packs: charmfile-core, charmfile-memory' "$test_root/status.txt"
assert_contains 'Freshness: current' "$test_root/status.txt"
assert_contains 'Decisions: 1 proposed for optional review' "$test_root/status.txt"
assert_contains 'Read-only: no configuration, plugins, or memory were changed.' "$test_root/status.txt"

[ "$manifest_before" = "$(shasum -a 256 "$manifest" | awk '{print $1}')" ] ||
  fail 'resume or status changed the project manifest'
[ "$note_before" = "$(shasum -a 256 "$note_path" | awk '{print $1}')" ] ||
  fail 'resume or status changed the memory note'
[ "$config_before" = "$(shasum -a 256 "$config_path" | awk '{print $1}')" ] ||
  fail 'resume or status changed the Sidecar config'
[ "$health_before" = "$(shasum -a 256 "$health_path" | awk '{print $1}')" ] ||
  fail 'resume or status changed cached health'

if run_charmfile resume --repo "$project_root" --yes \
  > "$test_root/resume-write-flag.txt" 2>&1; then
  fail 'resume accepted a write-approval flag'
fi
assert_contains 'resume is read-only and does not accept --yes' \
  "$test_root/resume-write-flag.txt"

if run_charmfile resume --repo "$uninitialized_root" \
  > "$test_root/resume-uninitialized.txt" 2>&1; then
  fail 'resume accepted an uninitialized project'
fi
assert_contains 'project is not initialized' "$test_root/resume-uninitialized.txt"

run_charmfile status --repo "$uninitialized_root" \
  > "$test_root/status-uninitialized.txt"
assert_contains 'Identity: not initialized · run charmfile init' \
  "$test_root/status-uninitialized.txt"
assert_contains 'Freshness: unavailable until project init' \
  "$test_root/status-uninitialized.txt"

printf '[ok] portable init plan/apply/preservation, resume, cached status, unavailable states, and read-only guarantees\n'

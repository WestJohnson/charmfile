#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
browser="$repo_root/plugins/charmfile-browser/skills/browser-setup/scripts/charmfile-browser"
extension_id="mmlmfjhmonkocbjadbfplnigmagldckm"

test_root="$(mktemp -d)"
trap 'find "$test_root" -depth -delete' EXIT
fake_bin="$test_root/bin"
test_home="$test_root/home"
chrome_app="$test_root/Google Chrome.app"
chrome_root="$test_home/Library/Application Support/Google/Chrome"
mkdir -p \
  "$fake_bin" \
  "$test_home" \
  "$chrome_app" \
  "$chrome_root/Default/Extensions/$extension_id"

cat > "$fake_bin/uname" <<'EOF'
#!/bin/sh
printf '%s\n' "${MOCK_OS:-Darwin}"
EOF

cat > "$fake_bin/node" <<'EOF'
#!/bin/sh
printf 'v20.18.0\n'
EOF

cat > "$fake_bin/jq" <<'EOF'
#!/bin/sh
if [ "${1:-}" = "--version" ]; then
  printf 'jq-1.7\n'
  exit 0
fi
exit 2
EOF

cat > "$fake_bin/npm" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [ "${1:-}" = "--version" ]; then
  printf '10.8.0\n'
  exit 0
fi
[ "${1:-}" = "install" ]
shift
prefix=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefix)
      prefix="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
[ -n "$prefix" ]
mkdir -p "$prefix/node_modules/.bin"
cat > "$prefix/node_modules/.bin/playwright-cli" <<'INNER'
#!/bin/sh
case "${1:-}" in
  --version)
    printf '0.1.17\n'
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
INNER
chmod 755 "$prefix/node_modules/.bin/playwright-cli"
EOF

chmod 755 "$fake_bin/uname" "$fake_bin/node" "$fake_bin/npm" "$fake_bin/jq"
export PATH="$test_home/.local/bin:$fake_bin:/usr/bin:/bin"
export CHARMFILE_TARGET_HOME="$test_home"
export CHARMFILE_CHROME_APP="$chrome_app"
export CHARMFILE_CHROME_ROOT="$chrome_root"

"$browser" plan > "$test_root/plan.txt"
grep -Fq 'CLI wrapper: create' "$test_root/plan.txt"
grep -Fq 'Playwright Extension: detected' "$test_root/plan.txt"

if "$browser" install > "$test_root/unapproved.txt" 2>&1; then
  printf 'unapproved browser install unexpectedly succeeded\n' >&2
  exit 1
fi

"$browser" install --yes > "$test_root/install.txt"
test -x "$test_home/.local/bin/playwright-cli"
test -x \
  "$test_home/.local/share/charmfile/playwright-cli/node_modules/.bin/playwright-cli"
"$browser" doctor --require-live-chrome > "$test_root/doctor.txt"
grep -Fq 'Isolated Playwright: ready' "$test_root/doctor.txt"
grep -Fq 'Signed-in Chrome: ready for user-approved attachment' \
  "$test_root/doctor.txt"

rm -rf "$chrome_root/Default/Extensions/$extension_id"
"$browser" doctor > "$test_root/no-extension.txt"
grep -Fq 'Signed-in Chrome: action required' "$test_root/no-extension.txt"
if "$browser" doctor --require-live-chrome \
  > "$test_root/required-extension.txt" 2>&1; then
  printf 'required live Chrome doctor unexpectedly ignored a missing extension\n' >&2
  exit 1
fi

MOCK_OS="Linux"
export MOCK_OS
if "$browser" plan > "$test_root/non-macos.txt" 2>&1; then
  printf 'non-macOS browser plan unexpectedly succeeded\n' >&2
  exit 1
fi

printf '[ok] browser plan, approval, owned CLI, isolated readiness, live Chrome readiness, and macOS boundary\n'

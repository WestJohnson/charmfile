#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
helper="$repo_root/plugins/charmfile-core/skills/charmfile-setup/scripts/codex-secrets"

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT
fake_bin="$test_root/bin"
mkdir -p "$fake_bin"

cat > "$fake_bin/uname" <<'EOF'
#!/usr/bin/env sh
printf '%s\n' "${MOCK_OS:?}"
EOF

cat > "$fake_bin/security" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

action="${1:?}"
shift
service=""
value=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -s)
      service="$2"
      shift 2
      ;;
    -w)
      if [ "$#" -gt 1 ]; then
        value="$2"
        shift 2
      else
        shift
      fi
      ;;
    -a|-l)
      shift 2
      ;;
    -U)
      shift
      ;;
    *)
      shift
      ;;
  esac
done
store_file="${MOCK_SECRET_STORE:?}/$service"
case "$action" in
  add-generic-password)
    printf '%s' "$value" > "$store_file"
    ;;
  find-generic-password)
    cat "$store_file"
    ;;
  delete-generic-password)
    rm "$store_file"
    ;;
  *)
    exit 2
    ;;
esac
EOF

cat > "$fake_bin/secret-tool" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

action="${1:?}"
shift
name=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --label=*)
      shift
      ;;
    name)
      name="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
store_file="${MOCK_SECRET_STORE:?}/$name"
case "$action" in
  store)
    IFS= read -r value || true
    printf '%s' "$value" > "$store_file"
    ;;
  lookup)
    cat "$store_file"
    ;;
  clear)
    rm "$store_file"
    ;;
  *)
    exit 2
    ;;
esac
EOF

chmod 755 "$fake_bin/uname" "$fake_bin/security" "$fake_bin/secret-tool"
export PATH="$fake_bin:$PATH"
export USER="charmfile-test"

run_backend_test() {
  local operating_system="$1"
  local expected_backend="$2"
  local case_root="$test_root/$operating_system"
  local listed
  local registry

  mkdir -p "$case_root/config" "$case_root/store"
  export MOCK_OS="$operating_system"
  export MOCK_SECRET_STORE="$case_root/store"
  export XDG_CONFIG_HOME="$case_root/config"

  printf '%s\n' 'test-only-value' | "$helper" set SAMPLE_SECRET --stdin >/dev/null
  "$helper" has SAMPLE_SECRET
  [ "$("$helper" get SAMPLE_SECRET)" = "test-only-value" ]
  "$helper" run SAMPLE_SECRET -- \
    /bin/sh -c '[ "$SAMPLE_SECRET" = "test-only-value" ]'

  listed="$("$helper" list)"
  [ "$listed" = "SAMPLE_SECRET" ]
  registry="$case_root/config/charmfile/secrets/registry"
  grep -Fxq 'SAMPLE_SECRET' "$registry"
  if grep -Fq 'test-only-value' "$registry"; then
    printf 'registry leaked a secret value\n' >&2
    exit 1
  fi
  grep -Fq "Backend: $expected_backend" <("$helper" doctor)

  "$helper" remove SAMPLE_SECRET >/dev/null
  if "$helper" has SAMPLE_SECRET >/dev/null 2>&1; then
    printf 'removed secret still exists\n' >&2
    exit 1
  fi
}

run_backend_test Darwin macos-keychain
run_backend_test Linux libsecret

if printf '%s\n' 'test-only-value' | "$helper" set 1INVALID --stdin >/dev/null 2>&1; then
  printf 'invalid variable name unexpectedly succeeded\n' >&2
  exit 1
fi

if [ "$(/usr/bin/uname -s)" = "Darwin" ]; then
  native_config="$test_root/native-config"
  mkdir -p "$native_config"
  PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
    XDG_CONFIG_HOME="$native_config" \
    "$helper" doctor >/dev/null
fi

printf '[ok] secret helper macOS, Linux, injection, registry, deletion, validation, and native doctor\n'

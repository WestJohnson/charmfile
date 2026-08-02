#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
version="${1:-0.2.0-rc.3}"

case "$version" in
  *[!0-9A-Za-z.-]*|'')
    printf 'invalid release version: %s\n' "$version" >&2
    exit 1
    ;;
esac

git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null
if [ -n "$(git -C "$repo_root" status --porcelain)" ]; then
  printf 'refusing to build from a dirty working tree\n' >&2
  exit 1
fi

"$repo_root/scripts/validate-release.sh"

artifact_dir="$repo_root/dist"
artifact="$artifact_dir/charmfile-$version.tar.gz"
checksum_file="$artifact_dir/SHA256SUMS"
mkdir -p "$artifact_dir"

git -C "$repo_root" archive \
  --format=tar \
  --prefix="charmfile-$version/" \
  HEAD |
  gzip -n > "$artifact"

(
  cd "$artifact_dir"
  shasum -a 256 "$(basename "$artifact")" > "$checksum_file"
)

printf 'release artifact: %s\n' "$artifact"
printf 'checksums: %s\n' "$checksum_file"

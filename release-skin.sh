#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf 'Usage: %s <skin-folder>\n' "$0" >&2
  exit 1
fi

skin_dir=$1
skin_name=$(basename "$skin_dir")

if [[ ! -d "$skin_dir" ]]; then
  printf 'Skin directory not found: %s\n' "$skin_dir" >&2
  exit 1
fi

if [[ ! -f LICENSE ]]; then
  printf 'LICENSE not found in repository root\n' >&2
  exit 1
fi

archive_name="${skin_name}.zip"
tmp_dir=$(mktemp -d)
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

cp -R "$skin_dir" "$tmp_dir/$skin_name"
cp LICENSE "$tmp_dir/$skin_name/LICENSE"

if [[ -f "$archive_name" ]]; then
  rm -f "$archive_name"
fi

(
  cd "$tmp_dir"
  zip -qr "$OLDPWD/$archive_name" "$skin_name"
)

printf '%s\n' "$archive_name"

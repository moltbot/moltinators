#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
shift || true
if [ -z "$file" ] || [ "$#" -eq 0 ]; then
  echo "Usage: memory-edit /memory/path.md '<command>'" >&2
  exit 2
fi

cmd="$*"

if ! flock -x -w 5 "$file" bash -c "$cmd"; then
  echo "memory-edit: lock timeout for $file" >&2
  exit 1
fi

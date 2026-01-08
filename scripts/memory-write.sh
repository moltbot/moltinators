#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "Usage: memory-write /memory/path.md" >&2
  exit 2
fi

mkdir -p "$(dirname "$file")"

if ! flock -x -w 5 "$file" bash -c 'cat > "$1"' _ "$file"; then
  echo "memory-write: lock timeout for $file" >&2
  exit 1
fi

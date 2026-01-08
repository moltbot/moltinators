#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "Usage: memory-read /memory/path.md" >&2
  exit 2
fi

if ! flock -s -w 5 "$file" cat "$file"; then
  echo "memory-read: lock timeout for $file" >&2
  exit 1
fi

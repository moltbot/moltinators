#!/usr/bin/env bash
set -euo pipefail

root="${1:-/memory}"

mkdir -p "$root/daily"

index="$root/index.md"
if [ ! -f "$index" ]; then
  cat > "$index" <<'EOM'
# Shared Memory Index

- Daily notes live in /memory/daily/YYYY-MM-DD.md
- Durable facts belong in /memory/project.md and /memory/architecture.md
EOM
fi

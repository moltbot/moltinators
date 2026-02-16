#!/usr/bin/env bash
set -euo pipefail

src="$1"
dst="$2"

if [ ! -d "$src" ]; then
  echo "seed-workspace: missing template dir: $src" >&2
  exit 1
fi

mkdir -p "$dst"

rsync_args=(
  -rlt
  --delete
  "--chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r"
  --exclude
  BOOTSTRAP.md
  "$src/"
  "$dst/"
)

set +e
rsync "${rsync_args[@]}"
code=$?
set -e

# rsync exit 23 is "partial transfer" and can happen if workspace contains root-owned
# files/dirs (e.g. manual edits). We prefer starting the gateway with a potentially
# stale workspace over a crash-loop.
if [ "$code" -eq 23 ]; then
  echo "seed-workspace: rsync returned 23; retrying without --delete" >&2
  rsync -rlt --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --exclude BOOTSTRAP.md "$src/" "$dst/"
elif [ "$code" -ne 0 ]; then
  exit "$code"
fi

if [ -f "/etc/clawdinator/tools.md" ]; then
  printf '\n%s\n' "$(cat /etc/clawdinator/tools.md)" >> "$dst/TOOLS.md"
fi

#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

PATHS=(
  "/mnt/appdata"
  "/mnt/downloads"
  "/mnt/media"
)

for p in "${PATHS[@]}"; do
  if [[ -d "$p" ]]; then
    echo "Setting ownership ${PUID}:${PGID} on $p"
    chown -R "${PUID}:${PGID}" "$p"
  else
    echo "SKIP (missing): $p"
  fi
done

echo "Permissions fixed."

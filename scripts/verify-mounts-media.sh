#!/usr/bin/env bash
set -euo pipefail

# Purpose: Ensure required mountpoints exist before starting Docker.
# If mounts are missing, Docker will write to the VM OS disk instead of ZFS.

REQUIRED_MOUNTS=(
  # "/mnt/downloads"
  # "/mnt/media"
)

missing=0

for p in "${REQUIRED_MOUNTS[@]}"; do
  if mountpoint -q "$p"; then
    echo "OK: $p"
  else
    echo "MISSING MOUNT: $p"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "ERROR: One or more required mounts are missing. Not starting Docker."
  exit 1
fi

echo "All required mounts present."

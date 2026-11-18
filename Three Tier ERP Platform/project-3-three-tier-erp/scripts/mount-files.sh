#!/usr/bin/env bash
# Mounts the Azure Files share. Run on a VM (vm-app should work, web VMs should be refused).
# NEVER commit a real key. Get it from: Storage account > Security + networking > Access keys.
set -euo pipefail
ACCOUNT="${1:?usage: STORAGE_KEY='...' bash mount-files.sh <storage-account-name>}"
: "${STORAGE_KEY:?set STORAGE_KEY in the environment first}"
sudo mkdir -p /mnt/casefiles
sudo mount -t cifs "//${ACCOUNT}.file.core.windows.net/casefiles" /mnt/casefiles \
  -o "username=${ACCOUNT},password=${STORAGE_KEY},vers=3.1.1,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30"
df -h /mnt/casefiles

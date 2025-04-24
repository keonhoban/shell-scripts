#!/usr/bin/env bash
set -euo pipefail

SRC_PATH=${1:-"/home/ubuntu"}
DST_PATH=${2:-"/backup/ubuntu_backup"}
ARCHIVE_NAME="$(date '+%F').tar.gz"
LOG_FILE="$DST_PATH/backup.log"

trap 'echo "[ERROR] Backup failed!" >> $LOG_FILE' ERR

mkdir -p "$DST_PATH"

if [[ -d "$SRC_PATH" ]]; then
    echo "[INFO] Backup started at $(date)" >> "$LOG_FILE"
    tar -czf "$DST_PATH/$ARCHIVE_NAME" -C "$SRC_PATH" . || exit 1
    echo "[INFO] Backup success: $ARCHIVE_NAME" >> "$LOG_FILE"
else
    echo "[ERROR] Source path not found: $SRC_PATH" >> "$LOG_FILE"
    exit 1
fi

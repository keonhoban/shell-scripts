#!/usr/bin/env bash
set -euo pipefail

# 인자 처리
MODE=${1:-"clean"}
TARGET_PATH=${2:-"/var/log"}
LOG_DIR=${3:-"/backup/logs"}
DAYS_OLD=${4:-30}
DATE=$(date '+%F')

mkdir -p "$LOG_DIR"

if [[ "$MODE" == "clean" ]]; then
    find "$TARGET_PATH" -type f -mtime +$DAYS_OLD -exec ls -lh {} \; > "$LOG_DIR/cleaned_$DATE.log"
    find "$TARGET_PATH" -type f -mtime +$DAYS_OLD -delete
    echo "[CLEAN] Done: $DATE"

elif [[ "$MODE" == "archive" ]]; then
    ARCHIVE="$LOG_DIR/logs_${DAYS_OLD}days_$DATE.tar.gz"
    find "$TARGET_PATH" -type f -name "*.log" -mtime +$DAYS_OLD -print | tar czf "$ARCHIVE" -T - || echo "No logs to archive"
    echo "[ARCHIVE] Done: $ARCHIVE"

else
    echo "Usage: $0 [clean|archive] [path] [log_dir] [days]"
    exit 1
fi

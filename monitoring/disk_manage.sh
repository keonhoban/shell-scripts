#!/usr/bin/env bash
set -euo pipefail

# 인자 또는 기본값 설정
LOG_PATH=${1:-"/var/log"}
DELETE_CYCLE_DAYS=${2:-5}
THRESHOLD_USAGE=${3:-80}
LOG_FILE="${LOG_PATH}/$(date '+%F')_delete.log"
TARGET_DISKS=("/" "/mnt/data" "/home")

# 로그 기록 함수
log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG_FILE"
}

# 디스크 사용량 기반 로그 삭제
log "[START] Disk usage check and cleanup for $LOG_PATH"

df -PTh | awk 'NR > 1 {print $6, $7}' | while read -r usage_percent mount_path; do
    usage=${usage_percent%\%}  # "%" 제거

    for target in "${TARGET_DISKS[@]}"; do
        if [[ "$mount_path" == "$target" && $usage -ge $THRESHOLD_USAGE ]]; then
            log "[INFO] Usage $usage% on $mount_path exceeds threshold ($THRESHOLD_USAGE%). Cleaning logs older than $DELETE_CYCLE_DAYS days..."
            
            old_files=$(find "$LOG_PATH" -type f -mtime +"$DELETE_CYCLE_DAYS")
            if [[ -z "$old_files" ]]; then
                log "[INFO] No old log files found in $LOG_PATH"
            else
                echo "$old_files" | xargs ls -lh >> "$LOG_FILE"
                echo "$old_files" | xargs rm -f
                log "[DONE] Deleted $(echo "$old_files" | wc -l) files."
            fi
        fi
    done
done

log "[END] Cleanup completed."


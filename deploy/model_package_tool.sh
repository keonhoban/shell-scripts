#!/usr/bin/env bash
set -euo pipefail

MODE=${1:-"check"}  # check, archive, restore, deploy
TARGET_DIR=${2:-"/opt/ml/models"}
ARCHIVE_FILE=${3:-"models.tar.gz"}
REQUIRED_FILES=("model.py" "requirements.txt" "config.yaml")

# 간단한 로그 함수
log() { echo "[$(date '+%F %T')] $1"; }

# 1. 필수 파일 존재 여부 확인
check() {
    [[ -d "$TARGET_DIR" ]] || { log "Missing dir: $TARGET_DIR"; exit 1; }
    for file in "${REQUIRED_FILES[@]}"; do
        [[ -e "$TARGET_DIR/$file" ]] || { log "Missing file: $file"; exit 1; }
    done
    log "File check complete"
}

# 2. 모델 디렉토리 압축
archive() {
    mkdir -p "$TARGET_DIR"
    tar -czf "$ARCHIVE_FILE" -C "$TARGET_DIR" .
    log "Archive created: $ARCHIVE_FILE"
}

# 3. 압축된 모델 복원
restore() {
    [[ -e "$ARCHIVE_FILE" ]] || { log "Missing archive: $ARCHIVE_FILE"; exit 1; }
    mkdir -p "$TARGET_DIR"
    tar -xzf "$ARCHIVE_FILE" -C "$TARGET_DIR"
    log "Restore done to $TARGET_DIR"
}

# 4. 모델 원격 서버로 전송
deploy() {
    USER=${4:-"ubuntu"}
    HOST=${5:-"127.0.0.1"}
    DEST=${6:-"/opt/ml/models"}
    scp "$ARCHIVE_FILE" "$USER@$HOST:$DEST" \
        && log "Deployed to $HOST" \
        || { log "Deployment failed"; exit 1; }
}

# 실행 분기
case "$MODE" in
    check)   check ;;
    archive) archive ;;
    restore) restore ;;
    deploy)  deploy "$@" ;;
    *)
        echo "Usage: $0 [check|archive|restore|deploy] [target_dir] [archive_file] [user] [host] [remote_path]"
        exit 1
        ;;
esac


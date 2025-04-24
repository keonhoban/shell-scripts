# 🐚 MLOps 운영 자동화를 위한 Shell Script 모음

운영 환경에서 반복되는 작업들을 자동화하기 위한 Bash 스크립트 모음입니다.

모든 스크립트는 **Ubuntu 환경에서 실무 적용 가능하도록 설계**되었으며,

**유연한 인자 사용, 안전한 예외 처리, 로그 기록**을 기본으로 구성되어 있습니다.

---

## 📁 디렉토리 구조

```
shell_scripts_blog/
├── backup/           # 백업 및 복원
├── data_processing/  # 로그 정리 및 아카이브
├── deploy/           # 모델 패키징 및 배포
├── monitoring/       # 디스크 사용량 기반 정리

```

---

## 📄 스크립트 요약

### 🗂️ backup

| 파일명 | 설명 |
| --- | --- |
| `backup_daily.sh` | `/home/ubuntu` 디렉토리를 매일 압축 백업 후 로그 기록 |

| 인자 | 설명 | 기본값 |
| --- | --- | --- |
| `$1` | 백업 대상 디렉토리 경로 | `/home/ubuntu` |
| `$2` | 백업 파일 저장 디렉토리 | `/backup/ubuntu_backup` |

---

### 🛠️ data_processing

| 파일명 | 설명 |
| --- | --- |
| `log_manager.sh` | 오래된 로그 삭제(`clean`) 또는 `.log` 파일 압축 후 백업(`archive`) |

| 인자 | 설명 | 기본값 |
| --- | --- | --- |
| `$1` | 모드 (`clean` 또는 `archive`) | `clean` |
| `$2` | 로그 경로 | `/var/log` |
| `$3` | 로그 저장 디렉토리 | `/backup/logs` |
| `$4` | 기준 일 수 (며칠 지난 파일 대상) | `30` |

---

### 📦 deploy

| 파일명 | 설명 |
| --- | --- |
| `model_package_tool.sh` | 모델 디렉토리 검사, 압축, 복원, 원격 전송까지 처리 (`check`, `archive`, `restore`, `deploy` 모드 사용) |

| 인자 | 설명 | 기본값 |
| --- | --- | --- |
| `$1` | 모드 (`check`, `archive`, `restore`, `deploy`) | `check` |
| `$2` | 모델 디렉토리 경로 | `/opt/ml/models` |
| `$3` | 압축 파일명 | `models.tar.gz` |
| `$4~$6` | `deploy` 모드에서만 사용됨: 사용자, 호스트, 원격 경로 | `ubuntu`, `127.0.0.1`, `/opt/ml/models` |

---

### 🔧 monitoring

| 파일명 | 설명 |
| --- | --- |
| `disk_manage.sh` | 디스크 사용량이 임계치 이상일 때 오래된 로그 자동 삭제 (삭제 전 목록 기록 포함) |

| 인자 | 설명 | 기본값 |
| --- | --- | --- |
| `$1` | 로그가 위치한 경로 | `/var/log` |
| `$2` | 삭제 기준 일 수 | `5` |
| `$3` | 디스크 사용률 임계치 (%) | `80` |

---

## 💡 실행 예시 (인자 포함 설명)

```bash
# backup_daily.sh: /home/ubuntu → /backup/ubuntu_backup 로 백업 (기본값 사용)
./backup/backup_daily.sh

# log_manager.sh: /var/log 내 30일 이상 지난 로그 삭제 후 /backup/logs에 기록
./data_processing/log_manager.sh clean /var/log /backup/logs 30

# log_manager.sh: /home/user/project 내 30일 이상 지난 .log 파일 압축하여 백업
./data_processing/log_manager.sh archive /home/user/project /backup/logs 30

# model_package_tool.sh: 모델 디렉토리 압축
./deploy/model_package_tool.sh archive /opt/ml/models model.tar.gz

# model_package_tool.sh: 원격 서버로 배포 (model.tar.gz → ubuntu@192.168.1.10:/opt/ml/models)
./deploy/model_package_tool.sh deploy /opt/ml/models model.tar.gz ubuntu 192.168.1.10 /opt/ml/models

# disk_manage.sh: /var/log 기준, 사용률 80% 초과 시 5일 지난 로그 삭제
./monitoring/disk_manage.sh /var/log 5 80

```

---

## ✅ 시스템 환경

| 항목 | 설명 |
| --- | --- |
| OS | Ubuntu 24.04 이상 |
| Shell | bash 5.x 이상 |
| 도구 | `df`, `find`, `tar`, `scp`, `xargs`, `tee`, `ls`, `mkdir`, `awk` 등 |
| 권한 | 일부 스크립트는 `sudo` 필요 |

---

## **🏁** 마무리

> 반복을 줄이는 자동화보다 더 중요한 건,
> 
> 
> **운영을 신뢰할 수 있도록 만드는 자동화**라고 생각합니다. 감사합니다! 😊
>

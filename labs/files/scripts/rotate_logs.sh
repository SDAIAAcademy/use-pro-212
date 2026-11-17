#!/usr/bin/env bash
# Compresses the rotated logs of the booking system. The current log and the audit log
# are left as they are. Run from the server root. Usage: rotate_logs.sh
set -euo pipefail
LOG_DIR=./srv/pms/logs

for f in "$LOG_DIR"/pms-app.log.[0-9]*; do
  [ -e "$f" ] || continue
  case "$f" in
    *.gz) continue ;;
  esac
  gzip "$f"
  echo "compressed $f"
done

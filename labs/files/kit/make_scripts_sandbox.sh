#!/usr/bin/env bash
# Builds the disposable copy of the server tree that the four scripts of lab 2.1 work on,
# and prints its folder. Usage: bash kit/make_scripts_sandbox.sh
set -eu
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SB="$(mktemp -d "${TMPDIR:-/tmp}/sura-scr.XXXXXX")"
SB="$(cd "$SB" && pwd)"
: > "$SB/.sura-sandbox"
mkdir -p "$SB/srv/cache/sessions" "$SB/srv/backup" "$SB/srv/accounts" "$SB/srv/pms/logs" "$SB/bin" "$SB/work"
: > "$SB/srv/cache/sessions/index.tsv"
for n in 1 2 3 4 5 6 7 8 9; do
  for k in 1 2 3 4; do
    printf 'h0%s\tsess-%s%s%s7\tu1%s%s2\n' "$n" "$n" "$k" "$n" "$k" "$n" >> "$SB/srv/cache/sessions/index.tsv"
  done
done
for m in 07 08 09; do
  echo "backup 2026-$m" > "$SB/srv/backup/pms-2026-$m.tar.gz"
  touch -t 202601010000 "$SB/srv/backup/pms-2026-$m.tar.gz"
done
echo "backup of last night" > "$SB/srv/backup/pms-latest.tar.gz"
echo "database dump of last night" > "$SB/srv/backup/db-latest.dump"
printf 'account\tdays_since_last_login\nu1042\t3\nu1203\t127\nu1344\t95\nu1601\t12\nu2290\t210\nsvc-backup\t9999\nsvc-archive\t9999\n' > "$SB/srv/accounts/last_login.tsv"
echo "current log" > "$SB/srv/pms/logs/pms-app.log"
echo "rotated log 1" > "$SB/srv/pms/logs/pms-app.log.1"
echo "rotated log 2" > "$SB/srv/pms/logs/pms-app.log.2"
echo "audit trail" > "$SB/srv/pms/logs/audit.log"
printf '%s\n' srv/cache/sessions/index.tsv srv/backup/pms-latest.tar.gz srv/backup/db-latest.dump \
  srv/pms/logs/audit.log srv/pms/logs/pms-app.log srv/accounts/last_login.tsv > "$SB/PROTECTED.txt"
cp "$KIT/shims/usermod" "$SB/bin/usermod"
chmod +x "$SB/bin/usermod" 2>/dev/null || true
echo "$SB"

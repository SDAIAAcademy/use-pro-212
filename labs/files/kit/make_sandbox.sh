#!/usr/bin/env bash
# Builds the disposable copy of the booking server for lab 1.2 and prints its folder.
# It holds the state of incident INC-2291: a full log volume and a stopped service.
# Usage: SB="$(bash kit/make_sandbox.sh)"      (a new temporary folder every time)
set -eu
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SB="$(mktemp -d "${TMPDIR:-/tmp}/sura-sb.XXXXXX")"
SB="$(cd "$SB" && pwd)"
: > "$SB/.sura-sandbox"
mkdir -p "$SB/srv/pms/logs" "$SB/srv/pms/etc" "$SB/srv/pms/state" "$SB/srv/backup" "$SB/bin"
fill() { # fill <file> <kilobytes> <line>
  yes "$3" 2>/dev/null | head -c $(($2 * 1024)) > "$1" || true
}
for n in 1 2 3 4 5; do
  fill "$SB/srv/pms/logs/pms-app.log.$n" 700 "2026-11-0$((6 - n))T02:00:00+03:00 pms-02 level=DEBUG action=rates.sync hotel=h0$n payload=0000000000000000000000000000000000000000"
done
fill "$SB/srv/pms/logs/pms-app.log" 250 "2026-11-06T23:10:00+03:00 pms-02 level=DEBUG action=rates.sync hotel=h07 payload=0000000000000000000000000000000000000000"
fill "$SB/srv/pms/logs/audit.log" 120 "2026-11-06T22:00:00+03:00 pms-02 audit acct=u1422 action=folio.post hotel=h02 result=ok"
printf 'service=pms-app\nlog_level=debug\ndebug_port=9229\nlog_dir=srv/pms/logs\n' > "$SB/srv/pms/etc/pms-app.conf"
echo stopped > "$SB/srv/pms/state/service"
echo 4096 > "$SB/srv/capacity_kb"
cp "$KIT/sandbox_bin/dfree" "$KIT/sandbox_bin/svcctl" "$SB/bin/"
chmod +x "$SB/bin/dfree" "$SB/bin/svcctl" 2>/dev/null || true
echo "$SB"

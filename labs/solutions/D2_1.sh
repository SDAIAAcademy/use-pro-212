#!/usr/bin/env bash
# Lab 2.1, review, lint and dry-run four scripts. Ends with PASS when every check holds.
# Every script runs only through kit/dryrun.sh, inside a new disposable sandbox.
source "$(dirname "$0")/common.sh"
set +e
S="$FILES/scripts"
codes() { bash "$KIT/lint.sh" "$1" 2>&1 | grep -o 'SC[0-9]*' | LC_ALL=C sort -u | tr '\n' ' '; }
field() { grep '^== summary' "$1" | sed -E "s/.* $2=([^ ]+).*/\1/"; }

echo "== static analysis"
c1="$(codes "$S/drop_hotel_sessions.sh")"; echo "drop_hotel_sessions.sh: $c1"
c2="$(codes "$S/purge_backups.sh")"; echo "purge_backups.sh: ${c2:-clean}"
c3="$(codes "$S/lock_stale_accounts.sh")"; echo "lock_stale_accounts.sh: $c3"
c4="$(codes "$S/rotate_logs.sh")"; echo "rotate_logs.sh: ${c4:-clean}"
case "$c1" in *SC2094*) ok "lint names the destructive line of drop_hotel_sessions.sh (SC2094)" ;; *) fail "SC2094 expected" ;; esac
expect "lint findings in purge_backups.sh (its destructive line is invisible to lint)" "${c2:-clean}" clean
case "$c3" in *SC2086*) ok "lint warns about quoting in lock_stale_accounts.sh" ;; *) fail "SC2086 expected" ;; esac
expect "lint findings in rotate_logs.sh" "${c4:-clean}" clean

echo "== dry run of the four scripts as generated"
bash "$KIT/dryrun.sh" "$S/drop_hotel_sessions.sh" h03 > s1.out 2>&1; cat s1.out
expect "drop_hotel_sessions.sh h03: protected files lost or emptied" "$(field s1.out protected_lost)" 1
grep -q 'index.tsv  720 -> 0' s1.out && ok "the session index of all nine hotels is emptied" || fail "the index should be emptied"
bash "$KIT/dryrun.sh" "$S/purge_backups.sh" > s2.out 2>&1; cat s2.out
expect "purge_backups.sh: files deleted" "$(field s2.out deleted)" 5
expect "purge_backups.sh: protected files lost" "$(field s2.out protected_lost)" 2
bash "$KIT/dryrun.sh" "$S/lock_stale_accounts.sh" > s3.out 2>&1; cat s3.out
expect "lock_stale_accounts.sh: protected files lost" "$(field s3.out protected_lost)" 0
expect "lock_stale_accounts.sh: accounts it would lock" "$(grep '   > usermod -L' s3.out | sed 's/.*-L //' | tr '\n' ' ')" "u1203 u1344 u2290 "
bash "$KIT/dryrun.sh" "$S/rotate_logs.sh" > s4.out 2>&1; cat s4.out
expect "rotate_logs.sh: protected files lost" "$(field s4.out protected_lost)" 0
expect "rotate_logs.sh: logs compressed" "$(grep -c '   + srv/pms/logs/pms-app.log.[12].gz' s4.out)" 2

echo "== the corrected scripts pass lint and dry run"
expect "lint findings in the corrected drop_hotel_sessions.sh" "$(codes "$SOL/drop_hotel_sessions_fixed.sh")" ""
bash "$KIT/dryrun.sh" "$SOL/drop_hotel_sessions_fixed.sh" h03 > f1.out 2>&1; rc=$?; cat f1.out
expect "corrected, with h03: exit code of the dry run" "$rc" 0
grep -q 'index.tsv  720 -> 640' f1.out && ok "only the four sessions of h03 are dropped (720 to 640 bytes)" || fail "expected 720 -> 640"
sb="$(field f1.out sandbox)"
expect "corrected, with h03: lines of h03 left" "$(grep -c '^h03' "$sb/srv/cache/sessions/index.tsv" || true)" 0
expect "corrected, with h03: lines left" "$(wc -l < "$sb/srv/cache/sessions/index.tsv" | tr -d ' ')" 32
bash "$KIT/dryrun.sh" "$SOL/drop_hotel_sessions_fixed.sh" > f1b.out 2>&1; cat f1b.out
expect "corrected, without a hotel code: protected files lost" "$(field f1b.out protected_lost)" 0
[ "$(field f1b.out exit)" != 0 ] && ok "corrected, without a hotel code: stops with an error and changes nothing" || fail "should stop"
expect "lint findings in the corrected purge_backups.sh" "$(codes "$SOL/purge_backups_fixed.sh")" ""
bash "$KIT/dryrun.sh" "$SOL/purge_backups_fixed.sh" > f2.out 2>&1; rc=$?; cat f2.out
expect "corrected purge: exit code of the dry run" "$rc" 0
expect "corrected purge: files deleted (the three old backups)" "$(field f2.out deleted)" 3
echo "PASS lab 2.1"

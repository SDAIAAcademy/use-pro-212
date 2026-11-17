#!/usr/bin/env bash
# Lab 1.2, test a drafted runbook. Runs the draft and then the reference runbook, each in
# its own disposable sandbox, and ends with PASS when every check holds.
source "$(dirname "$0")/common.sh"
set +e

echo "== the sandbox holds the state of the incident"
SB="$(bash "$KIT/make_sandbox.sh")"
source "$KIT/sandbox_env.sh" "$SB" > /dev/null
[ -f "$SB/.sura-sandbox" ] || fail "no sandbox"
before_pct="$(dfree -p)"
dfree
[ "$before_pct" -ge 90 ] || fail "the log volume should be at least 90% full, it is $before_pct%"
ok "log volume at $before_pct%"
svcctl status pms-app; expect "service before any step (exit code of status)" "$?" 1
audit_sum="$(cksum < srv/pms/logs/audit.log)"

echo "== the five faults of the drafted runbook show when its steps are run"
DRAFT=()
while IFS= read -r line; do DRAFT+=("$line"); done < <(sed -n 's/^[$] //p' "$FILES/incident/sahir_runbook_draft.md")
expect "commands in the recorded draft" "${#DRAFT[@]}" 5
expect "draft step 1 as written" "${DRAFT[0]}" "du -sh --top 5 srv/pms/logs"
step D1 "${DRAFT[0]}" > /dev/null 2>&1
[ "$?" -ne 0 ] && ok "draft step 1: the flag --top does not exist, the command fails" || fail "du --top should fail"
step D2 "${DRAFT[1]}" > d2.out 2>&1; rc=$?
grep -q 'no space left' d2.out && [ "$rc" -ne 0 ] && ok "draft step 2: start before space is freed fails" || fail "start should fail on a full volume"
step D3 "${DRAFT[2]}" > /dev/null 2>&1
[ ! -e srv/pms/logs/audit.log ] && ok "draft step 3: the audit log is gone" || fail "the draft's delete should remove audit.log"
expect "draft step 3: rotated logs still there" "$(find srv/pms/logs -name 'pms-app.log.[1-5]' | wc -l | tr -d ' ')" 5
after_rm="$(dfree -p)"
[ "$after_rm" -ge 80 ] && ok "draft step 3: the volume is still at $after_rm%" || fail "the delete should free little"
step D4 "${DRAFT[3]}" > /dev/null 2>&1
step D5 "${DRAFT[4]}" > d5.out 2>&1; rc=$?
grep -q 'audit trail missing' d5.out && [ "$rc" -ne 0 ] && ok "draft step 5: the service refuses to start without its audit trail" || fail "start should fail without audit.log"
expect "draft: steps in the run log" "$(grep -c '^## step' "$SB/run_log.txt")" 5
ok "the draft has no verification step and no rollback (read, not run)"

echo "== the reference runbook in a new sandbox"
SB="$(bash "$KIT/make_sandbox.sh")"
source "$KIT/sandbox_env.sh" "$SB" > /dev/null
step 1 'dfree' || fail "step 1"
step 2 'svcctl status pms-app'; expect "step 2: status says stopped (exit code)" "$?" 1
step 3 'du -ak srv/pms/logs | sort -rn | head -6' || fail "step 3"
step 4 'tar -cf srv/backup/pre-change.tar srv/pms/etc/pms-app.conf && cksum < srv/pms/logs/audit.log > srv/backup/audit.cksum' || fail "step 4"
step 5 'gzip srv/pms/logs/pms-app.log.[1-5] && dfree' || fail "step 5"
mid_pct="$(dfree -p)"
[ "$mid_pct" -lt 80 ] && ok "step 5: log volume down to $mid_pct%" || fail "space was not freed: $mid_pct%"
step 6 "sed 's/^log_level=debug\$/log_level=info/' srv/pms/etc/pms-app.conf > srv/pms/etc/pms-app.conf.new && mv srv/pms/etc/pms-app.conf.new srv/pms/etc/pms-app.conf && grep '^log_level=' srv/pms/etc/pms-app.conf" || fail "step 6"
expect "step 6: log level" "$(grep '^log_level=' srv/pms/etc/pms-app.conf)" "log_level=info"
expect "step 6: the other setting is untouched" "$(grep -c '^debug_port=9229$' srv/pms/etc/pms-app.conf)" 1
step 7 'svcctl start pms-app' || fail "step 7"
step 8 'svcctl status pms-app && cksum < srv/pms/logs/audit.log | diff - srv/backup/audit.cksum && dfree' || fail "step 8: verification"
expect "audit log unchanged" "$(cksum < srv/pms/logs/audit.log)" "$audit_sum"
expect "steps in the run log" "$(grep -c '^## step' "$SB/run_log.txt")" 8
expect "failed steps in the run log (step 2 reports a stopped service)" "$(grep -c '^exit=[1-9]' "$SB/run_log.txt")" 1

echo "== the rollback returns the server to the state before the change"
step R1 'svcctl stop pms-app' || fail "rollback 1"
step R2 'tar -xf srv/backup/pre-change.tar && gunzip srv/pms/logs/pms-app.log.[1-5].gz' || fail "rollback 2"
expect "rollback: log level" "$(grep '^log_level=' srv/pms/etc/pms-app.conf)" "log_level=debug"
expect "rollback: rotated logs uncompressed" "$(find srv/pms/logs -name 'pms-app.log.[1-5]' | wc -l | tr -d ' ')" 5
expect "rollback: audit log unchanged" "$(cksum < srv/pms/logs/audit.log)" "$audit_sum"
echo "numbers for the slides: before $before_pct%, after the draft's delete $after_rm%, after step 5 $mid_pct%"
echo "PASS lab 1.2"

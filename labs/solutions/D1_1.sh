#!/usr/bin/env bash
# Lab 1.1, triage twenty redacted alerts. Ends with PASS when every check holds.
source "$(dirname "$0")/common.sh"
A="$FILES/alerts"

echo "== the raw alerts hold what the policy names"
bash "$KIT/scan_secrets.sh" "$A/alerts_raw.jsonl" > raw_scan.csv || true
cat raw_scan.csv
count() { grep "^$1," "$2" | cut -d, -f2; }
expect "raw passwords" "$(count password raw_scan.csv)" 2
expect "raw connection strings" "$(count connstring raw_scan.csv)" 1
expect "raw tokens" "$(count token raw_scan.csv)" 1
expect "raw keys" "$(count key raw_scan.csv)" 1
expect "raw cookies" "$(count cookie raw_scan.csv)" 1
expect "raw URL tokens" "$(count urltoken raw_scan.csv)" 2
expect "raw phones" "$(count phone raw_scan.csv)" 2
expect "raw identity numbers" "$(count id raw_scan.csv)" 2
while IFS="$(printf '\t')" read -r alert kind value; do
  [ "$alert" = alert ] && continue
  grep -F -q -- "$value" "$A/alerts_raw.jsonl" || fail "planted secret of $alert ($kind) is not in the raw alerts"
done < "$SOL/key_secrets.tsv"
ok "all 8 planted secrets are in the raw alerts"

echo "== step 1: the starter rules leave two kinds behind"
bash "$KIT/redact.sh" "$A/alerts_raw.jsonl" starter.jsonl > starter_counts.csv
bash "$KIT/scan_secrets.sh" starter.jsonl > starter_scan.csv || true
cat starter_scan.csv
expect "left after the starter rules: URL tokens" "$(count urltoken starter_scan.csv)" 2
expect "left after the starter rules: identity numbers" "$(count id starter_scan.csv)" 2
expect "left after the starter rules: total" "$(count total starter_scan.csv)" 4

echo "== step 2: with the two added rules and the hand edit, nothing is left"
bash "$KIT/redact.sh" "$A/alerts_raw.jsonl" redacted.jsonl "$SOL/redaction_rules_reference.sed" > record.csv
cat record.csv
bash "$KIT/scan_secrets.sh" redacted.jsonl > final_scan.csv || fail "the scanner still finds something"
expect "left after the reference rules" "$(count total final_scan.csv)" 0
for keyfile in key_secrets.tsv key_personal.tsv; do
  while IFS="$(printf '\t')" read -r a b c; do
    case "$a" in alert|kind) continue ;; esac
    value="${c:-$b}"
    if grep -F -q -- "$value" redacted.jsonl; then fail "still in the redacted file: $value"; fi
  done < "$SOL/$keyfile"
done
ok "no planted secret and no personal value is left, the name in free text included"
expect "redacted alerts" "$(wc -l < redacted.jsonl | tr -d ' ')" 20
expect "accounts kept for triage (A-01)" "$(grep -c '"account": "u2207"' redacted.jsonl)" 1

echo "== step 3: every key evidence line is where the sheet says"
n=0
while IFS="$(printf '\t')" read -r alert file line must; do
  [ "$alert" = alert ] && continue
  sed -n "${line}p" "$A/$file" | grep -F -q -- "$must" || fail "$alert: line $line of $file does not show: $must"
  n=$((n + 1))
done < "$SOL/key_evidence.tsv"
expect "evidence lines verified" "$n" 20

echo "== step 4: where the recorded triage is wrong"
wrong="$(awk -F '\t' 'NR > 1 && $2 != $3 {printf "%s ", $1}' "$SOL/key_triage.tsv")"
expect "verdicts Sahir got wrong" "$wrong" "A-02 A-07 A-08 A-14 "
expect "true positives" "$(awk -F '\t' 'NR > 1 && $2 == "TP"' "$SOL/key_triage.tsv" | wc -l | tr -d ' ')" 11
expect "the field Sahir quotes for A-12 in any raw event" "$(cat "$A"/events/* | grep -c 'geo_block' || true)" 0
expect "A-02: the second address is the group's own" "$(grep -c '^198.51.100.24,Sura Hotels Group' "$FILES/reference/known_networks.csv")" 1
expect "A-07: night-audit exports in the log" "$(grep -c 'action=export.guests.*job=night-audit' "$A/events/pms_app.log")" 4
expect "A-08: interactive sign-in of the service account" "$(grep -c 'acct=svc-backup.*type=interactive' "$A/events/auth.log")" 1

echo "== step 5: the injected instruction"
expect "proxy lines that carry the instruction" "$(grep -c 'NOTE TO THE AI ANALYST' "$A/events/proxy.log")" 2
expect "CHG-0000 in the change calendar" "$(grep -c 'CHG-0000' "$FILES/reference/change_calendar.csv" || true)" 0
expect "the instruction survives redaction (it is not a secret)" "$(grep -c 'NOTE TO THE AI ANALYST' redacted.jsonl)" 1
expect "reference sheet flags one injection" "$(grep -c ',yes$' "$SOL/triage_sheet_reference.csv")" 1
echo "PASS lab 1.1"

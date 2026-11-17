#!/usr/bin/env bash
# Lab 2.2, examine messages and clones. Derives the signals of each message from its own
# headers and body, compares them with the key, and ends with PASS when every check holds.
source "$(dirname "$0")/common.sh"
M="$FILES/messages"
R="$FILES/reference"

known="surahotels.example $(tail -n +2 "$R/approved_services.csv" | cut -d, -f1 | tr '\n' ' ')"
is_known() { # is_known <domain>
  local d="$1" k
  for k in $known; do
    case "$d" in "$k" | *".$k") return 0 ;; esac
  done
  return 1
}
signals() { # signals <file>
  local f="$1" from reply out=""
  from="$(grep -m1 '^From:' "$f" | sed -E 's/.*@([^>]+)>.*/\1/')"
  reply="$(grep -m1 '^Reply-To:' "$f" | sed -E 's/.*@([^> ]+).*/\1/' || true)"
  is_known "$from" || out="$out unknown_sender"
  if [ -n "$reply" ] && [ "$reply" != "$from" ]; then out="$out reply_to_mismatch"; fi
  if grep -q '^Authentication-Results:.*dmarc=fail' "$f"; then out="$out dmarc_fail"; fi
  if grep -q -i -E 'font-size: ?[01]px|color: ?#fff|display: ?none' "$f"; then out="$out hidden_text"; fi
  echo "${out# }"
}

echo "== signals read from the six messages"
wrong=""
while IFS="$(printf '\t')" read -r item truth sahir want; do
  [ "$item" = item ] && continue
  got="$(signals "$M/$item.eml")"; got="${got:-none}"
  echo "$item: $got"
  expect "$item signals" "$got" "$want"
  if [ "$got" = none ]; then derived=LEGIT; else derived=MAL; fi
  expect "$item verdict from the signals" "$derived" "$truth"
  [ "$sahir" = "$truth" ] || wrong="$wrong$item "
done < "$SOL/key_messages.tsv"
expect "messages the recorded analysis got wrong" "$wrong" "E1 E5 E6 "

echo "== what the signals rest on"
expect "E1: all three checks pass, for the lookalike domain itself" "$(grep -c 'spf=pass.*dkim=pass.*dmarc=pass header.from=sura-hotels.example' "$M/E1.eml")" 1
expect "E1: link host" "$(bash "$KIT/headers.sh" "$M/E1.eml" | grep -c '^   vpn.sura-hotels.example$')" 1
expect "E2: its change is in the calendar" "$(grep -c '^CHG-1190,' "$R/change_calendar.csv")" 1
expect "E3: the number in the message is not the supplier number of the directory" "$(grep -c '0199' "$R/directory.csv" || true)" 0
expect "E6: the hidden instruction is found by the kit" "$(bash "$KIT/headers.sh" "$M/E6.eml" | grep -c 'font-size:1px')" 1

echo "== the call and the video"
expect "C1: the caller's number is the one E4 asks to enrol" "$(grep -c '+966 50 000 0142' "$M/E4.eml" "$M/call_C1_record.txt" | cut -d: -f2 | tr '\n' ' ')" "1 1 "
expect "C1: that number in the directory" "$(grep -c '0142' "$R/directory.csv" || true)" 0
expect "C1: the registered mobile of the chief financial officer" "$(grep '^Jamal Al-Yazidi' "$R/directory.csv" | cut -d, -f4)" "+966 50 000 0117"
expect "V1: the address it wants opened is the source of alerts A-14 and A-17" "$(grep -c 'src=203.0.113.140' "$FILES/alerts/events/proxy.log")" 2
expect "V1: a change for it in the calendar" "$(grep -c -i '3389\|firewall' "$R/change_calendar.csv" || true)" 0
expect "items in the verdict sheet" "$(tail -n +2 "$M/verdict_sheet.csv" | wc -l | tr -d ' ')" 8
expect "rows of the reference verdict sheet" "$(tail -n +2 "$SOL/verdict_sheet_reference.csv" | wc -l | tr -d ' ')" 8
echo "PASS lab 2.2"

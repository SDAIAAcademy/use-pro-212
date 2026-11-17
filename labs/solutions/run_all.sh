#!/usr/bin/env bash
# Runs the four solution scripts and prints one line per lab. Usage: bash labs/solutions/run_all.sh
SOL="$(cd "$(dirname "$0")" && pwd)"
LOGS="$(mktemp -d "${TMPDIR:-/tmp}/sura-logs.XXXXXX")"
failed=0
for s in D1_1 D1_2 D2_1 D2_2; do
  if bash "$SOL/$s.sh" > "$LOGS/$s.log" 2>&1 && tail -n 1 "$LOGS/$s.log" | grep -q '^PASS'; then
    echo "$s PASS ($(grep -c '^ok:' "$LOGS/$s.log") checks)"
  else
    echo "$s FAIL (see $LOGS/$s.log)"
    failed=1
  fi
done
echo "logs: $LOGS"
exit $failed

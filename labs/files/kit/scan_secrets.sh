#!/usr/bin/env bash
# Scans a file for the patterns of secrets and personal data that the redaction policy names.
# Prints one count per kind and ends with exit code 1 when anything is left.
# A clean scan is not a clean file: a pattern scanner cannot see a name inside free text.
# Usage: bash kit/scan_secrets.sh <file>
set -eu
f="${1:?usage: scan_secrets.sh <file>}"
total=0
scan() {
  local kind="$1" pattern="$2" n
  n=$(grep -o -E -- "$pattern" "$f" | wc -l | tr -d ' ')
  echo "$kind,$n"
  total=$((total + n))
}
echo "kind,left"
scan name '"(user_name|guest_name)": "[^]["]'
scan password "(password=[^[& \"']|--password '[^[])"
scan connstring '://[^:/@ ]+:[^@[ ]+@'
scan token 'sura_pat_[A-Za-z0-9]'
scan key 'SURA-KEY-[A-Z0-9]'
scan cookie 'PMSSESSION=[a-f0-9]'
scan urltoken '[?&](access_)?token=[A-Za-z0-9]'
scan email '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[a-z]+'
scan phone '\+9665[0-9]{8}'
scan id '(national_id|guest_id)=[12][0-9]{9}'
echo "total,$total"
[ "$total" -eq 0 ]

#!/usr/bin/env bash
# Redacts a file with the rules of redaction_rules.sed and counts each placeholder.
# Usage: bash kit/redact.sh <input> <output> [rules file]
set -eu
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
in="${1:?usage: redact.sh <input> <output> [rules file]}"
out="${2:?usage: redact.sh <input> <output> [rules file]}"
rules="${3:-$KIT/redaction_rules.sed}"
[ "$in" != "$out" ] || { echo "redact.sh: the output must be a new file, the raw file stays as it is" >&2; exit 2; }
sed -E -f "$rules" "$in" > "$out"
echo "placeholder,count"
for p in '[NAME]' '[EMAIL]' '[PHONE]' '[ID]' '[SECRET:password]' '[SECRET:token]' '[SECRET:key]' '[SECRET:cookie]' '[SECRET:urltoken]'; do
  n=$(grep -o -F -- "$p" "$out" | wc -l | tr -d ' ')
  echo "$p,$n"
done

#!/usr/bin/env bash
# Dry run of one script of lab 2.1: runs it for real, but only inside a new disposable copy
# of the server tree, and reports what it did to that copy.
# Usage: bash kit/dryrun.sh <script> [arguments of the script]
set -u
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script="${1:?usage: dryrun.sh <script> [arguments]}"; shift
[ -f "$script" ] || { echo "dryrun.sh: no such script: $script" >&2; exit 2; }
SB="$(bash "$KIT/make_scripts_sandbox.sh")"
[ -f "$SB/.sura-sandbox" ] || { echo "dryrun.sh: no sandbox, nothing was run" >&2; exit 2; }
cp "$script" "$SB/work/script.sh"
cd "$SB" || exit 2
[ -f ./.sura-sandbox ] || { echo "dryrun.sh: not inside the sandbox, nothing was run" >&2; exit 2; }
manifest() { find srv -type f -exec wc -c {} + 2>/dev/null | grep -v ' total$' | awk '{print $2 "\t" $1}' | LC_ALL=C sort; }
echo "== syntax (bash -n)"
if bash -n work/script.sh; then echo "ok"; else echo "syntax error: nothing was run"; exit 1; fi
manifest > before.txt
echo "== run in the sandbox: $(basename "$script") $*"
PATH="$SB/bin:$PATH" bash work/script.sh "$@" 2>&1 | sed 's/^/   | /'
rc=${PIPESTATUS[0]}
echo "exit=$rc"
manifest > after.txt
cut -f1 before.txt > before.names
cut -f1 after.txt > after.names
echo "== files deleted"
LC_ALL=C comm -23 before.names after.names | sed 's/^/   - /'
echo "== files created"
LC_ALL=C comm -13 before.names after.names | sed 's/^/   + /'
echo "== files whose size changed (name, bytes before, bytes after)"
LC_ALL=C join -t "$(printf '\t')" before.txt after.txt | awk -F '\t' '$2 != $3 {print "   ~ " $1 "  " $2 " -> " $3}'
echo "== calls to system commands (stand-ins)"
if [ -f calls.log ]; then sed 's/^/   > /' calls.log; fi
lost=0
while IFS= read -r p; do
  if [ ! -s "$p" ]; then echo "PROTECTED FILE LOST OR EMPTIED: $p"; lost=$((lost + 1)); fi
done < PROTECTED.txt
echo "== summary: exit=$rc deleted=$(LC_ALL=C comm -23 before.names after.names | wc -l | tr -d ' ') protected_lost=$lost sandbox=$SB"
[ "$lost" -eq 0 ]

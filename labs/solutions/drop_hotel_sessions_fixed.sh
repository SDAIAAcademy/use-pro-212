#!/usr/bin/env bash
# Signs out every session of one hotel by removing its lines from the session index.
# Run from the server root. Usage: drop_hotel_sessions.sh <hotel code, for example h03>
set -eu
HOTEL="${1:?usage: drop_hotel_sessions.sh <hotel code, for example h03>}"
case "$HOTEL" in
  h0[1-9]) ;;
  *) echo "unknown hotel code: $HOTEL" >&2; exit 2 ;;
esac
INDEX=./srv/cache/sessions/index.tsv
NEW="$INDEX.new"

echo "Dropping the sessions of hotel $HOTEL"
awk -F '\t' -v hotel="$HOTEL" '$1 != hotel' "$INDEX" > "$NEW"
mv "$NEW" "$INDEX"
echo "Sessions left: $(wc -l < "$INDEX")"

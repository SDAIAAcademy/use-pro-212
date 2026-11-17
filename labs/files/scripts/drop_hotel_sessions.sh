#!/usr/bin/env bash
# Signs out every session of one hotel by removing its lines from the session index.
# Run from the server root. Usage: drop_hotel_sessions.sh <hotel code, for example h03>
HOTEL=$1
INDEX=./srv/cache/sessions/index.tsv

echo "Dropping the sessions of hotel $HOTEL"
grep -v "^$HOTEL" $INDEX > $INDEX
echo "Sessions left: $(wc -l < $INDEX)"

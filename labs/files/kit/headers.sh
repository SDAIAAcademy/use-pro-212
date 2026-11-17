#!/usr/bin/env bash
# Prints the lines of a saved message (.eml) that a verdict rests on: who it claims to be
# from, where a reply goes, what the receiving server checked, and every host it links to.
# Usage: bash kit/headers.sh <message.eml>
set -eu
f="${1:?usage: headers.sh <message.eml>}"
echo "== $(basename "$f")"
grep -n -i -E '^(From|Reply-To|Return-Path|To|Subject|Authentication-Results):' "$f" || true
echo "-- hosts in links"
grep -o -i -E 'https?://[^/"<> ]+' "$f" | sed -E 's#^https?://##' | LC_ALL=C sort -u | sed 's/^/   /'
echo "-- hidden text (tiny or white text, hidden blocks, comments)"
grep -n -i -E 'font-size: ?[01]px|color: ?#fff|display: ?none|<!--' "$f" || echo "   none found by pattern"

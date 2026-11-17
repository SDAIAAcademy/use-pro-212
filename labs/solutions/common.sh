# shellcheck shell=bash
# Shared by every solution script. Each script works in a new temporary folder outside the
# course and never writes into the repository. No model is called anywhere.
set -eu
SOL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABS="$(cd "$SOL/.." && pwd)"
FILES="$LABS/files"
KIT="$FILES/kit"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/sura-sol.XXXXXX")"
cd "$WORK"
ok() { echo "ok: $*"; }
fail() { echo "FAIL: $*"; exit 1; }
# expect <description> <actual> <expected>
expect() { if [ "$2" = "$3" ]; then ok "$1 = $2"; else fail "$1: got '$2', expected '$3'"; fi; }

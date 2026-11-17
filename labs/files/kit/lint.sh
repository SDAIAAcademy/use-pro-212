#!/usr/bin/env bash
# Static analysis of shell scripts with ShellCheck. Uses the installed program when there is
# one, otherwise runs it through uv. Usage: bash kit/lint.sh <script> [more scripts]
set -u
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "$@"
elif command -v uv >/dev/null 2>&1; then
  uv tool run --from shellcheck-py shellcheck "$@"
else
  echo "lint.sh: install ShellCheck (https://www.shellcheck.net) or uv" >&2; exit 2
fi

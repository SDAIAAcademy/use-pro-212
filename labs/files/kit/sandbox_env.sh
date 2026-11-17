# shellcheck shell=bash
# Source this file to work inside a sandbox made by make_sandbox.sh:
#   source kit/sandbox_env.sh "$SB"
# It moves you into the sandbox, puts its tools (dfree, svcctl) on PATH and defines "step",
# which runs one runbook step from the sandbox root and writes it to run_log.txt:
#   step 1 'dfree'
if [ -z "${1:-}" ] || [ ! -f "$1/.sura-sandbox" ]; then
  echo "sandbox_env.sh: give the folder printed by make_sandbox.sh" >&2
  return 2 2>/dev/null || exit 2
fi
SB="$(cd "$1" && pwd)"
export SB
case ":$PATH:" in *":$SB/bin:"*) ;; *) PATH="$SB/bin:$PATH" ;; esac
export PATH
cd "$SB" || return 2
step() {
  local n="${1:?step <number> '<command>'}"; shift
  local cmd="$*" out rc
  if [ ! -f "$SB/.sura-sandbox" ]; then echo "step: no sandbox, nothing was run" >&2; return 2; fi
  # The sandbox is a folder, not a wall: refuse a command that names a place outside it.
  # This catches what is written, not what a variable expands to: read every step first.
  if printf '%s\n' "${cmd//\/dev\/null/}" | grep -q -E '(^|[[:space:];|&<>(=])(/|~)|(^|[^[:alnum:]_])sudo([^[:alnum:]_]|$)|\.\.(/|$|[[:space:]])'; then
    echo "step: the command names a path outside the sandbox (an absolute path, ~, .. or sudo); nothing was run" >&2; return 2
  fi
  out="$(cd "$SB" && bash -c "$cmd" 2>&1)"; rc=$?
  { echo "## step $n  $(date -u +%Y-%m-%dT%H:%M:%SZ)"; echo "\$ $cmd"; [ -z "$out" ] || printf '%s\n' "$out"; echo "exit=$rc"; echo; } >> "$SB/run_log.txt"
  [ -z "$out" ] || printf '%s\n' "$out"
  echo "[step $n] exit=$rc"
  return $rc
}
echo "sandbox: $SB  (tools: dfree, svcctl; log: run_log.txt)"

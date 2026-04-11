#!/usr/bin/env bash
# Timing instrumentation for sketchybar + aerospace calls.
#
# Sourced by sketchybarrc and every plugin that calls these binaries.
# When enabled, defines shadow shell functions `aerospace` and `sketchybar`
# that wrap the real binaries (via `command`), measure wall time with
# $EPOCHREALTIME (bash 5 builtin, zero subprocesses), and append one line
# per call to $TIMELOG_FILE. Subshells inherit the functions, so
# $(aerospace ...) is also instrumented.
#
# Enable: comment out the `return 0` line below.
# Tail with: tail -f /tmp/sketchybar-timelog.log
# See docs/about-04-sketchybar.md for the full rationale.

# No-op stub so sketchybarrc can call _timelog_session unconditionally even
# when profiling is disabled. The real implementation below overrides this.
_timelog_session() { :; }

# ── DISABLED BY DEFAULT — comment the next line to re-enable profiling ──
# return 0
# ────────────────────────────────────────────────────────────────────────

TIMELOG_FILE="${TIMELOG_FILE:-/tmp/sketchybar-timelog.log}"

# Bash 5+ is required for $EPOCHREALTIME. Fail loud but don't break plugins.
if [[ -z $BASH_VERSION || ${BASH_VERSION%%.*} -lt 5 ]]; then
    printf '[ ????ms] timelog              WARN bash<5 (%s) — instrumentation OFF\n' \
        "${BASH_VERSION:-unknown}" >> "$TIMELOG_FILE" 2>/dev/null
    return 0 2>/dev/null || true
fi

_timelog_call() {
    local bin=$1; shift
    local t0=$EPOCHREALTIME
    command "$bin" "$@"
    local rc=$?
    local t1=$EPOCHREALTIME

    # $EPOCHREALTIME format: "<secs>.<usecs>" with exactly 6 decimals
    local s0=${t0%.*} u0=${t0#*.}
    local s1=${t1%.*} u1=${t1#*.}
    local us=$(( (10#$s1 - 10#$s0) * 1000000 + 10#$u1 - 10#$u0 ))
    (( us < 0 )) && us=0
    local ms=$(( us / 1000 ))

    local caller=${0##*/}
    local cmd="$bin $*"
    if [ ${#cmd} -gt 90 ]; then
        cmd="${cmd:0:60}...${cmd: -27}"
    fi

    printf '[%5dms] %-20s %s\n' "$ms" "$caller" "$cmd" >> "$TIMELOG_FILE" 2>/dev/null
    return $rc
}

aerospace()  { _timelog_call aerospace  "$@"; }
sketchybar() { _timelog_call sketchybar "$@"; }

_timelog_session() {
    printf '\n=== session %s (pid %s) ===\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" "$$" >> "$TIMELOG_FILE" 2>/dev/null
}

#!/usr/bin/env bash
# Throwaway: print the focused window every 5s from multiple sources.

BOLD=$'\033[1m'
DIM=$'\033[2m'
RED=$'\033[31m'
GRN=$'\033[32m'
YLW=$'\033[33m'
BLU=$'\033[34m'
MAG=$'\033[35m'
CYN=$'\033[36m'
RST=$'\033[0m'

row() {
  # $1 = label (colored), $2 = value
  printf "  ${BOLD}%-12s${RST} %s\n" "$1" "$2"
}

section() {
  printf "${DIM}─── %s ───${RST}\n" "$1"
}

while true; do
  printf "\n${BOLD}${BLU}╭─ %s ──────────────────────────╮${RST}\n" "$(date +%H:%M:%S)"

  section "aerospace"
  line=$(aerospace list-windows --focused --format '%{app-name}│%{window-title}│%{window-id}│%{workspace}' 2>&1)
  if [[ $line == *"│"* ]]; then
    IFS='│' read -r app title wid ws <<< "$line"
    row "${GRN}app${RST}"       "$app"
    row "${GRN}title${RST}"     "$title"
    row "${GRN}window id${RST}" "$wid"
    row "${GRN}workspace${RST}" "$ws"
  else
    printf "  ${RED}%s${RST}\n" "$line"
  fi

  section "lsappinfo / CGS frontmost"
  asn=$(lsappinfo front 2>/dev/null)
  if [[ -n $asn ]]; then
    name=$(lsappinfo info -only name     "$asn" 2>/dev/null | sed -E 's/.*=\"([^"]*)\".*/\1/')
    bid=$(lsappinfo  info -only bundleid "$asn" 2>/dev/null | sed -E 's/.*=\"([^"]*)\".*/\1/')
    pid=$(lsappinfo  info -only pid      "$asn" 2>/dev/null | sed -E 's/.*=([0-9]+).*/\1/')
    exe=""
    if [[ -n $pid ]]; then
      exe=$(ps -p "$pid" -o comm= 2>/dev/null)
    fi
    row "${CYN}name${RST}"      "$name"
    row "${CYN}bundle id${RST}" "$bid"
    row "${CYN}pid${RST}"       "$pid"
    row "${CYN}asn${RST}"       "$asn"
    [[ -n $exe ]] && row "${CYN}exec${RST}" "$exe"
  else
    printf "  ${RED}(no frontmost app)${RST}\n"
  fi

  section "AppleScript"
  as_out=$(osascript <<'EOF' 2>&1
    tell application "System Events"
      set frontApp to first application process whose frontmost is true
      set appName to name of frontApp
      try
        set winTitle to name of front window of frontApp
      on error
        set winTitle to "(no window)"
      end try
      return appName & "│" & winTitle
    end tell
EOF
)
  if [[ $as_out == *"│"* ]]; then
    IFS='│' read -r app title <<< "$as_out"
    row "${MAG}app${RST}"   "$app"
    row "${MAG}title${RST}" "$title"
  else
    # Permission error or other; show a short hint
    short=$(printf '%s' "$as_out" | head -n1)
    printf "  ${YLW}skipped:${RST} ${DIM}%s${RST}\n" "$short"
    printf "  ${DIM}(grant Terminal/Ghostty access in System Settings → Privacy & Security → Automation)${RST}\n"
  fi

  printf "${BOLD}${BLU}╰──────────────────────────────────────╯${RST}\n"
  sleep 5
done

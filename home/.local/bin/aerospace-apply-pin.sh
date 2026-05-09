#!/bin/bash
# Applies an entry from ~/.config/aerospace-locks/registry.json to a window
# that AeroSpace just detected. Invoked from `[[on-window-detected]]` with
# `$AEROSPACE_WINDOW_ID` set.
#
# Registry key convention (see aerospace-toggle-pin.sh):
#   - "<bundle-id>" for .app-bundled apps (preferred).
#   - "name:<app-name>" for un-bundled processes (dev-mode Tauri etc.).
# We try the bundle-id first; if no entry matches, fall back to name lookup.
#
# Logs every invocation to /tmp/aerospace-apply-pin.log so failures are
# debuggable. Tail it with: `tail -f /tmp/aerospace-apply-pin.log`.

LOG="/tmp/aerospace-apply-pin.log"
log() { printf '%s %s\n' "$(date '+%H:%M:%S')" "$*" >>"$LOG"; }

REG="$HOME/.config/aerospace-locks/registry.json"

if [ -z "$AEROSPACE_WINDOW_ID" ]; then
  log "skip: AEROSPACE_WINDOW_ID empty (called outside on-window-detected?)"
  exit 0
fi

if [ ! -f "$REG" ]; then
  log "skip wid=$AEROSPACE_WINDOW_ID: registry $REG missing"
  exit 0
fi

# Resolve the window's bundle-id, app-name and current workspace by scanning
# `--all`. (AeroSpace 0.20.3-Beta has no `--window-id` flag on `list-windows`;
# the only way to look up a window by id is to enumerate everything.)
#
# `on-window-detected` fires before AeroSpace has fully populated bundle-id
# for fresh windows (verified on 0.20.3-Beta against Calculator: empty at t=0,
# present by t≈400ms; aerospace prints the literal "NULL-APP-BUNDLE-ID" while
# unresolved). Retry briefly so the pin still applies on cold launches.
BID=""
NAME=""
CURRENT_WS=""
for attempt in 1 2 3 4 5 6 7 8 9 10; do
  LINE=$(/opt/homebrew/bin/aerospace list-windows --all \
         --format '%{window-id}|%{app-bundle-id}|%{app-name}|%{workspace}' 2>/dev/null \
         | awk -F'|' -v wid="$AEROSPACE_WINDOW_ID" '$1==wid {print; exit}')
  if [ -n "$LINE" ]; then
    BID=$(printf '%s' "$LINE" | awk -F'|' '{print $2}')
    NAME=$(printf '%s' "$LINE" | awk -F'|' '{print $3}')
    CURRENT_WS=$(printf '%s' "$LINE" | awk -F'|' '{print $4}')
    if [ -n "$BID" ] && [ "$BID" != "NULL-APP-BUNDLE-ID" ]; then
      break
    fi
  fi
  sleep 0.1
done

if [ -z "$NAME" ] && { [ -z "$BID" ] || [ "$BID" = "NULL-APP-BUNDLE-ID" ]; }; then
  log "skip wid=$AEROSPACE_WINDOW_ID: no identifier resolved (window gone or 1s timeout)"
  exit 0
fi

# Try bundle-id first, then "name:<app-name>" fallback.
WS=""
KEY=""
if [ -n "$BID" ] && [ "$BID" != "NULL-APP-BUNDLE-ID" ]; then
  WS=$(jq -r --arg k "$BID" '.[$k] // empty' "$REG")
  [ -n "$WS" ] && KEY="$BID"
fi
if [ -z "$WS" ] && [ -n "$NAME" ]; then
  NK="name:$NAME"
  WS=$(jq -r --arg k "$NK" '.[$k] // empty' "$REG")
  [ -n "$WS" ] && KEY="$NK"
fi

if [ -z "$WS" ]; then
  log "skip wid=$AEROSPACE_WINDOW_ID bid=${BID:-?} name=${NAME:-?}: no registry entry"
  exit 0
fi

if [ "$CURRENT_WS" = "$WS" ]; then
  log "noop wid=$AEROSPACE_WINDOW_ID key=$KEY: already on ws=$WS"
  exit 0
fi

OUT=$(/opt/homebrew/bin/aerospace move-node-to-workspace \
      --window-id "$AEROSPACE_WINDOW_ID" "$WS" 2>&1)
RC=$?
if [ $RC -ne 0 ]; then
  log "fail wid=$AEROSPACE_WINDOW_ID key=$KEY -> ws=$WS (was=$CURRENT_WS) rc=$RC: $OUT"
else
  log "moved wid=$AEROSPACE_WINDOW_ID key=$KEY: ws=$CURRENT_WS -> ws=$WS"
fi

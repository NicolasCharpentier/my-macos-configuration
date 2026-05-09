#!/bin/bash
# Toggles a pin entry in ~/.config/aerospace-locks/registry.json for the
# currently-focused window. Bound to `p` in `[mode.shortcuts.binding]`.
#
# Registry key convention:
#   - bundle-id (e.g. "com.brave.Browser") for normal .app-bundled apps.
#   - "name:<app-name>" fallback for un-bundled processes (dev-mode Tauri,
#     raw binaries) where AeroSpace reports NULL-APP-BUNDLE-ID.
# Bundle-id is preferred because it survives renames and locale switches;
# app-name is a coarser fallback for the dev-bundle case only.

set -e
REG="$HOME/.config/aerospace-locks/registry.json"
mkdir -p "$(dirname "$REG")"
[ -f "$REG" ] || echo '{}' > "$REG"

# Try a few times: bundle-id may be momentarily unresolved on a freshly-
# launched app. After 500 ms we accept the app-name fallback rather than
# blocking the user.
KEY=""
WS=""
for attempt in 1 2 3 4 5 6 7 8 9 10; do
  LINE=$(/opt/homebrew/bin/aerospace list-windows --focused \
         --format '%{app-bundle-id}|%{app-name}|%{workspace}' 2>/dev/null) || exit 0
  BID=$(printf '%s' "$LINE" | awk -F'|' '{print $1}')
  NAME=$(printf '%s' "$LINE" | awk -F'|' '{print $2}')
  WS=$(printf '%s' "$LINE" | awk -F'|' '{print $3}')
  if [ -n "$BID" ] && [ "$BID" != "NULL-APP-BUNDLE-ID" ]; then
    KEY="$BID"
    break
  fi
  if [ "$attempt" -ge 5 ] && [ -n "$NAME" ]; then
    KEY="name:$NAME"
    break
  fi
  sleep 0.1
done

[ -z "$KEY" ] && exit 0
[ -z "$WS" ] && exit 0

if jq -e --arg k "$KEY" 'has($k)' "$REG" >/dev/null; then
  jq --arg k "$KEY" 'del(.[$k])' "$REG" > "$REG.tmp"
else
  jq --arg k "$KEY" --argjson w "$WS" '. + {($k): $w}' "$REG" > "$REG.tmp"
fi
mv "$REG.tmp" "$REG"
open -g "spotspaces://refresh-locks"

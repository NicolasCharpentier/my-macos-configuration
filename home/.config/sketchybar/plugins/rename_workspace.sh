#!/usr/bin/env bash

SID="$1"
FILE="$HOME/.config/aerospace/workspace-names"
mkdir -p "$(dirname "$FILE")"
touch "$FILE"

CURRENT=$(grep "^${SID}|" "$FILE" 2>/dev/null | cut -d'|' -f2-)

RESULT=$(osascript -e "display dialog \"Name for workspace ${SID}:\" default answer \"${CURRENT}\" buttons {\"Cancel\",\"OK\"} default button \"OK\"" -e 'text returned of result' 2>/dev/null)

if [ $? -eq 0 ]; then
    grep -v "^${SID}|" "$FILE" > "$FILE.tmp" 2>/dev/null || true
    if [ -n "$RESULT" ]; then
        echo "${SID}|${RESULT}" >> "$FILE.tmp"
    fi
    mv "$FILE.tmp" "$FILE"
    sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

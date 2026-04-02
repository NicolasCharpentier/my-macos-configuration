#!/usr/bin/env bash

SID="$1"
FILE="$HOME/.config/aerospace/workspace-names"
SUMMARIES="$HOME/.cache/workspace-summarizer/summaries.haiku"
ENABLED_FILE="$HOME/.cache/workspace-summarizer/enabled"
HASH_FILE="$HOME/.cache/workspace-summarizer/windows.hash"
mkdir -p "$(dirname "$FILE")"
touch "$FILE"

CURRENT=$(grep "^${SID}|" "$FILE" 2>/dev/null | cut -d'|' -f2-)

RESULT=$(osascript -e "display dialog \"Name for workspace ${SID}:\" default answer \"${CURRENT}\" buttons {\"Cancel\",\"OK\"} default button \"OK\"" -e 'text returned of result' 2>/dev/null)

if [ $? -eq 0 ]; then
    grep -v "^${SID}|" "$FILE" > "$FILE.tmp" 2>/dev/null || true
    if [ -n "$RESULT" ]; then
        echo "${SID}|${RESULT}" >> "$FILE.tmp"
        # Clear AI summary for this workspace (manual takes over)
        if [ -f "$SUMMARIES" ]; then
            grep -v "^${SID}|" "$SUMMARIES" > "$SUMMARIES.tmp" 2>/dev/null || true
            mv "$SUMMARIES.tmp" "$SUMMARIES"
        fi
    else
        # Manual name cleared — if AI is enabled, trigger regeneration
        if [ -f "$ENABLED_FILE" ]; then
            rm -f "$HASH_FILE"
            ~/.local/bin/workspace-summarizer-trigger &
        fi
    fi
    mv "$FILE.tmp" "$FILE"
    sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

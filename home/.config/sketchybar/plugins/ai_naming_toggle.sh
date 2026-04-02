#!/usr/bin/env bash
# Toggle AI workspace naming on/off

ENABLED_FILE="$HOME/.cache/workspace-summarizer/enabled"
mkdir -p "$(dirname "$ENABLED_FILE")"

if [ -f "$ENABLED_FILE" ]; then
    # Disable
    rm -f "$ENABLED_FILE"
else
    # Enable + immediate generation (bypass debounce)
    touch "$ENABLED_FILE"
    ~/.local/bin/workspace-summarizer &
fi

# Close popup, refresh icon state, refresh workspace display
sketchybar --set ai.naming popup.drawing=off
sketchybar --trigger ai_naming_changed 2>/dev/null
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"

#!/usr/bin/env bash

create_bubbles() {
    local file="$1"
    local prefix="$2"

    sketchybar --remove "/$prefix\./" 2>/dev/null

    CMD=()
    IDX=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        key="${line%%:*}"
        label="${line#*: }"
        ITEM="$prefix.$IDX"
        CMD+=(--add item "$ITEM" left)
        CMD+=(--set "$ITEM"
            background.drawing=on
            background.color=0x00000000
            background.border_color=0xffe1a860
            background.border_width=2
            background.corner_radius=5
            background.height=25
            icon="$key"
            icon.font="Hack Nerd Font:Bold:14.0"
            icon.color=0xff1e1e2e
            icon.background.drawing=on
            icon.background.color=0xffe1a860
            icon.background.height=25
            icon.background.corner_radius=5
            icon.padding_left=7
            icon.padding_right=7
            label=" $label"
            label.font="Hack Nerd Font:Regular:14.0"
            label.color=0xffffffff
            label.padding_left=0
            label.padding_right=20
        )
        IDX=$((IDX + 1))
    done < "$file"

    sketchybar "${CMD[@]}"
}

if [ "$MODE" = "service" ]; then
    sketchybar --remove '/shortcut\./' 2>/dev/null
    sketchybar --set '/unified\./' drawing=off \
               --set service.label label="SERVICE" drawing=on
    create_bubbles "$HOME/.config/sketchybar/service.txt" "shortcut"

elif [ "$MODE" = "shortcuts" ]; then
    sketchybar --remove '/shortcut\./' 2>/dev/null
    sketchybar --set '/unified\./' drawing=off \
               --set service.label label="SHORTCUTS" drawing=on
    create_bubbles "$HOME/.config/sketchybar/shortcuts.txt" "shortcut"

else
    sketchybar --remove '/shortcut\./' 2>/dev/null
    sketchybar --set service.label drawing=off \
               --set '/unified\.d.*\.mon\./' drawing=on \
               --set '/unified\.d.*\.sep\./' drawing=on
    # Let unified.sh restore workspace items
    FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
    sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"
fi

#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon_map.sh"

SID="$1"

if [ "$SENDER" = "mouse.entered" ]; then
    # Remove old popup items for this workspace item
    ESCAPED=$(echo "$NAME" | sed 's/\./\\./g')
    sketchybar --remove "/${ESCAPED}\.win\..*/" 2>/dev/null
    # Build popup items from window list
    WINDOWS=$(aerospace list-windows --workspace "$SID" --format '%{app-name}|%{window-title}' 2>/dev/null)
    IDX=0
    while IFS='|' read -r app title; do
        [ -z "$app" ] && continue
        __icon_map "$app"
        [ ${#title} -gt 50 ] && title="${title:0:47}..."
        ITEM="$NAME.win.$IDX"
        sketchybar --add item "$ITEM" popup."$NAME" \
            --set "$ITEM" \
                icon="$icon_result" \
                icon.font="sketchybar-app-font:Regular:14.0" \
                icon.color=0xffffffff \
                label="$app — $title" \
                label.font="Hack Nerd Font:Regular:12.0" \
                label.color=0xffffffff
        IDX=$((IDX + 1))
    done <<< "$WINDOWS"

    sketchybar --set "$NAME" popup.drawing=on
    exit 0
fi

if [ "$SENDER" = "mouse.exited" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
fi

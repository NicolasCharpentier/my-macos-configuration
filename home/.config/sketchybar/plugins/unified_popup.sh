#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/timelog.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

SID="$1"

if [ "$SENDER" = "mouse.entered" ]; then
    # Close all other popups first (workspace + stats + ai naming)
    sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
               --set cpu.stats popup.drawing=off \
               --set ram.stats popup.drawing=off \
               --set docker.stats popup.drawing=off \
               --set ai.naming popup.drawing=off 2>/dev/null

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
                icon.color=0xff3a3630 \
                label="$app — $title" \
                label.font="Hack Nerd Font:Regular:12.0" \
                label.color=0xff3a3630
        IDX=$((IDX + 1))
    done <<< "$WINDOWS"

    sketchybar --set "$NAME" popup.drawing=on

    # Auto-hide popup after 5 seconds
    PIDFILE="/tmp/sketchybar_popup_${NAME}.pid"
    kill "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null
    (sleep 5 && sketchybar --set "$NAME" popup.drawing=off) &
    echo $! > "$PIDFILE"

    exit 0
fi

if [ "$SENDER" = "mouse.exited" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    kill "$(cat "/tmp/sketchybar_popup_${NAME}.pid" 2>/dev/null)" 2>/dev/null
    exit 0
fi

#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/timelog.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

SID="$1"

# Handle mouse hover for popup
if [ "$SENDER" = "mouse.entered" ]; then
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

# Get window details for this workspace
WINDOWS=$(aerospace list-windows --workspace "$SID" --format '%{app-name}|%{window-title}' 2>/dev/null)

# Count windows
WIN_COUNT=$(echo "$WINDOWS" | grep -c '[^[:space:]]')

# Hide empty workspaces (unless focused)
if [ "$WIN_COUNT" -eq 0 ] && [ "$SID" != "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" drawing=off popup.drawing=off
    return 0 2>/dev/null || exit 0
fi

# Build app icons string
ICON_STRIP=""
while IFS='|' read -r app title; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    ICON_STRIP+=" $icon_result"
done <<< "$WINDOWS"
ICON_STRIP="${ICON_STRIP# }"

# Remove old popup items for this workspace
sketchybar --remove '/space\.'"$SID"'\.window\..*/' 2>/dev/null

# Add popup items (one per window: app icon + truncated title)
WIN_IDX=0
while IFS='|' read -r app title; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    # Truncate title to 50 chars
    [ ${#title} -gt 50 ] && title="${title:0:47}..."
    ITEM_NAME="space.$SID.window.$WIN_IDX"
    sketchybar --add item "$ITEM_NAME" popup.space."$SID" \
        --set "$ITEM_NAME" \
            icon="$icon_result" \
            icon.font="sketchybar-app-font:Regular:14.0" \
            icon.color=0xffffffff \
            label="$app — $title" \
            label.font="Hack Nerd Font:Regular:12.0" \
            label.color=0xffffffff
    WIN_IDX=$((WIN_IDX + 1))
done <<< "$WINDOWS"

# Style based on focus state
if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate sin 10 \
        --set "$NAME" \
            drawing=on \
            background.drawing=on \
            background.color=0xffe1a860 \
            background.border_color=0xffe1a860 \
            icon.color=0xff1e1e2e \
            label.drawing=on \
            label="$ICON_STRIP" \
            label.font="sketchybar-app-font:Regular:14.0" \
            label.color=0xff1e1e2e
else
    sketchybar --animate sin 10 \
        --set "$NAME" \
            drawing=on \
            background.drawing=on \
            background.color=0x00000000 \
            background.border_color=0xffffffff \
            icon.color=0xffffffff \
            label.drawing=on \
            label="$ICON_STRIP" \
            label.font="sketchybar-app-font:Regular:14.0" \
            label.color=0xffffffff
fi

#!/usr/bin/env bash

MID="$1"
MNAME="$2"

# Handle mouse hover for popup
if [ "$SENDER" = "mouse.entered" ]; then
    # Remove old popup items
    sketchybar --remove "/monitor\.${MID}\.info\..*/" 2>/dev/null

    # Full name
    sketchybar --add item monitor.$MID.info.name popup.monitor.$MID \
        --set monitor.$MID.info.name \
            icon="" \
            icon.font="Hack Nerd Font:Bold:14.0" \
            icon.color=0xffffffff \
            label="$MNAME" \
            label.font="Hack Nerd Font:Bold:13.0" \
            label.color=0xffffffff

    # Resolution & refresh rate from system_profiler
    DISPLAY_INFO=$(system_profiler SPDisplaysDataType 2>/dev/null)
    RESOLUTION=$(echo "$DISPLAY_INFO" | grep -A 5 "$MNAME" | grep "Resolution:" | sed 's/.*: //' | head -1)
    REFRESH=$(echo "$DISPLAY_INFO" | grep -A 5 "$MNAME" | grep "UI Looks like:" | grep -oE '[0-9.]+Hz' | head -1)

    if [ -n "$RESOLUTION" ]; then
        sketchybar --add item monitor.$MID.info.res popup.monitor.$MID \
            --set monitor.$MID.info.res \
                icon="" \
                icon.font="Hack Nerd Font:Bold:14.0" \
                icon.color=0xffffffff \
                label="$RESOLUTION" \
                label.font="Hack Nerd Font:Regular:12.0" \
                label.color=0xffaaaaaa
    fi

    if [ -n "$REFRESH" ]; then
        sketchybar --add item monitor.$MID.info.hz popup.monitor.$MID \
            --set monitor.$MID.info.hz \
                icon="󰍹" \
                icon.font="Hack Nerd Font:Bold:14.0" \
                icon.color=0xffffffff \
                label="$REFRESH" \
                label.font="Hack Nerd Font:Regular:12.0" \
                label.color=0xffaaaaaa

    fi

    # Main display status
    IS_MAIN=$(aerospace list-monitors --format '%{monitor-id}|%{monitor-is-main}' | grep "^${MID}|" | cut -d'|' -f2)
    if [ "$IS_MAIN" = "true" ]; then
        MAIN_LABEL="Main display"
    else
        MAIN_LABEL="Secondary display"
    fi
    sketchybar --add item monitor.$MID.info.main popup.monitor.$MID \
        --set monitor.$MID.info.main \
            icon="󰍺" \
            icon.font="Hack Nerd Font:Bold:14.0" \
            icon.color=0xffffffff \
            label="$MAIN_LABEL" \
            label.font="Hack Nerd Font:Regular:12.0" \
            label.color=0xffaaaaaa

    # Current workspace on this monitor
    VISIBLE=$(aerospace list-workspaces --monitor "$MID" --visible 2>/dev/null)
    sketchybar --add item monitor.$MID.info.ws popup.monitor.$MID \
        --set monitor.$MID.info.ws \
            icon="" \
            icon.font="Hack Nerd Font:Bold:14.0" \
            icon.color=0xffffffff \
            label="Workspace $VISIBLE" \
            label.font="Hack Nerd Font:Regular:12.0" \
            label.color=0xffaaaaaa

    sketchybar --set "$NAME" popup.drawing=on
    exit 0
fi

if [ "$SENDER" = "mouse.exited" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
fi

# Find which workspace is visible on this monitor
VISIBLE=$(aerospace list-workspaces --monitor "$MID" --visible 2>/dev/null)

# Check if this monitor has the focused workspace
FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)
FOCUSED_MON=$(aerospace list-windows --workspace "$FOCUSED_WS" --format '%{monitor-id}' 2>/dev/null | head -1)

# Fallback: check via visible workspaces
if [ -z "$FOCUSED_MON" ]; then
    FOCUSED_MON=$(aerospace list-workspaces --monitor all --visible --format '%{workspace}|%{monitor-id}|%{workspace-is-focused}' 2>/dev/null | grep '|true$' | cut -d'|' -f2)
fi

IS_FOCUSED=false
[ "$MID" = "$FOCUSED_MON" ] && IS_FOCUSED=true

if [ "$IS_FOCUSED" = true ]; then
    sketchybar --animate sin 10 \
        --set "$NAME" \
            label="${MNAME:0:5}" \
            background.drawing=on \
            background.color=0xffffffff \
            label.color=0xff1e1e2e
else
    sketchybar --animate sin 10 \
        --set "$NAME" \
            label="${MNAME:0:5}" \
            background.drawing=off \
            label.color=0xffffffff
fi

#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon_map.sh"

FOCUSED_WS="$FOCUSED_WORKSPACE"
[ -z "$FOCUSED_WS" ] && FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)

# Read previous workspace from persistent file (survives multiple event firings)
PREV_WS=""
[ -f /tmp/aerospace-prev-workspace ] && PREV_WS=$(cat /tmp/aerospace-prev-workspace)

# Close all popups on workspace change
sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
           --set cpu.stats popup.drawing=off \
           --set ram.stats popup.drawing=off \
           --set ai.naming popup.drawing=off 2>/dev/null

FOCUSED_MON=$(aerospace list-workspaces --monitor all --visible \
    --format '%{workspace}|%{monitor-id}|%{workspace-is-focused}' 2>/dev/null \
    | grep '|true$' | cut -d'|' -f2)

# Build display mapping (DirectDisplayID -> arrangement-id)
DISPLAYS_JSON=$(sketchybar --query displays 2>/dev/null)
declare -A DIRECT_TO_ARR
DISPLAY_IDS=()
while IFS='|' read -r arr_id direct_id; do
    DIRECT_TO_ARR["$direct_id"]="$arr_id"
    DISPLAY_IDS+=("$arr_id")
done < <(echo "$DISPLAYS_JSON" \
    | python3 -c "import json,sys; [print(f'{d[\"arrangement-id\"]}|{d[\"DirectDisplayID\"]}') for d in json.load(sys.stdin)]")

# Build monitor -> arrangement-id by order
# AeroSpace appkit-nsscreen-screens-id and SketchyBar DirectDisplayID use
# different numbering. Match monitors to displays by enumeration order instead.
declare -A MON_TO_ARR
declare -A MON_NAME
MONITOR_IDS=()
MON_IDX=0
while IFS='|' read -r mid mname; do
    MONITOR_IDS+=("$mid")
    MON_NAME["$mid"]="$mname"
    MON_TO_ARR["$mid"]="${DISPLAY_IDS[$MON_IDX]:-$((MON_IDX+1))}"
    MON_IDX=$((MON_IDX + 1))
done < <(aerospace list-monitors --format '%{monitor-id}|%{monitor-name}')

# Build workspace -> monitor mapping
declare -A WS_MON
while IFS='|' read -r ws mid; do
    [ -n "$ws" ] && WS_MON["$ws"]="$mid"
done < <(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# Read workspace custom names (manual)
declare -A WS_NAMES
NAMES_FILE="$HOME/.config/aerospace/workspace-names"
if [ -f "$NAMES_FILE" ]; then
    while IFS='|' read -r ws wname; do
        [ -n "$ws" ] && WS_NAMES["$ws"]="$wname"
    done < "$NAMES_FILE"
fi

# Read AI-generated names (used when no manual override exists)
declare -A AI_NAMES
SUMMARIES_FILE="$HOME/.cache/workspace-summarizer/summaries.haiku"
if [ -f "$SUMMARIES_FILE" ]; then
    while IFS='|' read -r ws ainame; do
        [ -n "$ws" ] && AI_NAMES["$ws"]="$ainame"
    done < "$SUMMARIES_FILE"
fi

# Get visible workspace per monitor (for non-focused monitor styling)
declare -A VISIBLE_WS
while IFS='|' read -r ws mid; do
    [ -n "$ws" ] && VISIBLE_WS["$ws"]="$mid"
done < <(aerospace list-workspaces --monitor all --visible --format '%{workspace}|%{monitor-id}')

# Pre-fetch all window icons per workspace
declare -A WS_ICONS
declare -A WS_WIN_COUNT
for sid in 1 2 3 4 5 6 7 8 9; do
    WINDOWS=$(aerospace list-windows --workspace "$sid" --format '%{app-name}' 2>/dev/null)
    WIN_COUNT=$(echo "$WINDOWS" | grep -c '[^[:space:]]')
    ICON_STRIP=""
    if [ "$WIN_COUNT" -gt 0 ]; then
        while IFS= read -r app; do
            [ -z "$app" ] && continue
            __icon_map "$app"
            ICON_STRIP+=" $icon_result"
        done <<< "$WINDOWS"
    fi
    WS_ICONS["$sid"]="${ICON_STRIP# }"
    WS_WIN_COUNT["$sid"]="$WIN_COUNT"
done

# ── Light theme colors ──
# Raised tab (visible):  #f0ede8 — matches desktop wallpaper (seamless)
# Lowered tab (other):   #e0dcd6 — slightly darker
# Active text:           #3a3630 — dark warm
# Inactive text:         #9a958d — muted
# Gold badge:            #e1a860 — warm gold
# Badge text:            #ffffff — white on gold
# Remote monitor:        ~30% opacity (ghosted)

CMD=()

for did in "${DISPLAY_IDS[@]}"; do
    for mid in "${MONITOR_IDS[@]}"; do
        IS_LOCAL=false; [ "${MON_TO_ARR[$mid]}" = "$did" ] && IS_LOCAL=true

        # Monitor label
        MLABEL="${MON_NAME[$mid]:0:5}"
        CMD+=(--set "unified.d$did.mon.$mid" drawing=on label="$MLABEL" label.color=0xff9a958d)

        for sid in 1 2 3 4 5 6 7 8 9; do
            BADGE="unified.d$did.ws.$mid.$sid.badge"
            CONTENT="unified.d$did.ws.$mid.$sid"
            TAB="unified.d$did.ws.$mid.$sid.tab"

            SPACER="unified.d$did.ws.$mid.$sid.spacer"

            if [ "${WS_MON[$sid]}" != "$mid" ]; then
                CMD+=(--set "$BADGE" drawing=off)
                CMD+=(--set "$CONTENT" drawing=off)
                CMD+=(--set "$TAB" background.drawing=off)
                CMD+=(--set "$SPACER" drawing=off)
                continue
            fi

            WIN_COUNT="${WS_WIN_COUNT[$sid]}"
            ICON_STRIP="${WS_ICONS[$sid]}"

            # Hide empty non-focused non-visible workspaces
            if [ "$WIN_COUNT" -eq 0 ] && [ "$sid" != "$FOCUSED_WS" ] && [ -z "${VISIBLE_WS[$sid]}" ]; then
                CMD+=(--set "$BADGE" drawing=off)
                CMD+=(--set "$CONTENT" drawing=off)
                CMD+=(--set "$TAB" background.drawing=off)
                CMD+=(--set "$SPACER" drawing=off)
                continue
            fi

            # Resolve workspace name: manual > AI > none
            WS_NAME="${WS_NAMES[$sid]}"
            if [ -z "$WS_NAME" ] && [ -n "${AI_NAMES[$sid]}" ]; then
                WS_NAME="${AI_NAMES[$sid]}"
            fi
            if [ -n "$WS_NAME" ]; then
                [ ${#WS_NAME} -gt 15 ] && WS_NAME="${WS_NAME:0:12}..."
            fi

            # ── LAYER 1: Tab shape ──
            MASK_DRAWING=off
            if [ "$sid" = "$FOCUSED_WS" ]; then
                # Focused: tall, extends below bar to hide bottom rounding
                TAB_BG=0xfff8f7f5
                TEXT_COLOR=0xff3a3630
                TAB_HEIGHT=45
                TAB_CORNER=9
                TAB_Y_OFFSET=-4
                TEXT_Y=0
            elif [ -n "${VISIBLE_WS[$sid]}" ]; then
                # Visible on other monitor: short pill + bottom mask
                TAB_BG=0xfff8f7f5
                TEXT_COLOR=0xff3a3630
                TAB_HEIGHT=34
                TAB_CORNER=8
                TAB_Y_OFFSET=-4
                TEXT_Y=-3
                MASK_DRAWING=on
            else
                # Inactive: short pill + bottom mask
                TAB_BG=0xfff8f7f5
                TEXT_COLOR=0xff8a857d
                TAB_HEIGHT=34
                TAB_CORNER=8
                TAB_Y_OFFSET=-4
                TEXT_Y=-3
                MASK_DRAWING=on
            fi

            # ── LAYER 2: Badge on number ──
            if [ "$sid" = "$FOCUSED_WS" ]; then
                BADGE_DRAWING=on
                BADGE_COLOR=0xffe1a860
                BADGE_TEXT=0xffffffff
            elif [ "$sid" = "$PREV_WS" ]; then
                BADGE_DRAWING=on
                BADGE_COLOR=0x40e1a860
                BADGE_TEXT=0x80e1a860
            else
                # Subtle muted badge for inactive tabs
                BADGE_DRAWING=on
                BADGE_COLOR=0xffd5d1cb
                BADGE_TEXT=0xff8a857d
            fi

            # Badge item (with flat bottom mask via item background)
            CMD+=(--set "$BADGE" drawing=on
                icon="$sid"
                icon.color="$BADGE_TEXT"
                icon.y_offset="$TEXT_Y"
                icon.background.drawing="$BADGE_DRAWING"
                icon.background.color="$BADGE_COLOR"
                background.drawing="$MASK_DRAWING"
                background.color="$TAB_BG"
                background.corner_radius=0
                background.height=18
                background.y_offset=-8
                background.padding_left=0
                background.padding_right=0)

            # Content item (with flat bottom mask via item background)
            CMD+=(--set "$CONTENT" drawing=on
                icon="$WS_NAME"
                icon.color="$TEXT_COLOR"
                icon.y_offset="$TEXT_Y"
                label="$ICON_STRIP"
                label.color="$TEXT_COLOR"
                label.y_offset="$TEXT_Y"
                background.drawing="$MASK_DRAWING"
                background.color="$TAB_BG"
                background.corner_radius=0
                background.height=18
                background.y_offset=-8
                background.padding_left=0
                background.padding_right=0)

            # Bracket tab background
            CMD+=(--set "$TAB"
                background.drawing=on
                background.color="$TAB_BG"
                background.height="$TAB_HEIGHT"
                background.corner_radius="$TAB_CORNER"
                background.y_offset="$TAB_Y_OFFSET")

            # Show gap spacer
            CMD+=(--set "$SPACER" drawing=on)
        done
    done
done

sketchybar "${CMD[@]}" 2>/dev/null

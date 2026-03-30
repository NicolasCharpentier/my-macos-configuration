#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon_map.sh"

FOCUSED_WS="$FOCUSED_WORKSPACE"
[ -z "$FOCUSED_WS" ] && FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)

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

# Build monitor -> arrangement-id and monitor -> name mappings
declare -A MON_TO_ARR
declare -A MON_NAME
MONITOR_IDS=()
while IFS='|' read -r mid appkit mname; do
    MONITOR_IDS+=("$mid")
    MON_TO_ARR["$mid"]="${DIRECT_TO_ARR[$appkit]:-$appkit}"
    MON_NAME["$mid"]="$mname"
done < <(aerospace list-monitors --format '%{monitor-id}|%{monitor-appkit-nsscreen-screens-id}|%{monitor-name}')

# Build workspace -> monitor mapping
declare -A WS_MON
while IFS='|' read -r ws mid; do
    [ -n "$ws" ] && WS_MON["$ws"]="$mid"
done < <(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# Read workspace custom names
declare -A WS_NAMES
NAMES_FILE="$HOME/.config/aerospace/workspace-names"
if [ -f "$NAMES_FILE" ]; then
    while IFS='|' read -r ws wname; do
        [ -n "$ws" ] && WS_NAMES["$ws"]="$wname"
    done < "$NAMES_FILE"
fi

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

# Build one big sketchybar command for efficiency
CMD=()

for did in "${DISPLAY_IDS[@]}"; do
    for mid in "${MONITOR_IDS[@]}"; do
        IS_LOCAL=false; [ "${MON_TO_ARR[$mid]}" = "$did" ] && IS_LOCAL=true
        IS_FOCUSED_MON=false; [ "$mid" = "$FOCUSED_MON" ] && IS_FOCUSED_MON=true

        # Monitor name: * suffix if local monitor
        MLABEL="${MON_NAME[$mid]:0:5}"
        if [ "$IS_LOCAL" = true ]; then
            CMD+=(--set "unified.d$did.mon.$mid" background.drawing=off label="${MLABEL}*" label.color=0xffffffff)
        else
            CMD+=(--set "unified.d$did.mon.$mid" background.drawing=off label="$MLABEL" label.color=0xffffffff)
        fi

        for sid in 1 2 3 4 5 6 7 8 9; do
            ITEM="unified.d$did.ws.$mid.$sid"

            if [ "${WS_MON[$sid]}" = "$mid" ]; then
                WIN_COUNT="${WS_WIN_COUNT[$sid]}"
                ICON_STRIP="${WS_ICONS[$sid]}"

                # Hide empty non-focused workspaces
                if [ "$WIN_COUNT" -eq 0 ] && [ "$sid" != "$FOCUSED_WS" ]; then
                    CMD+=(--set "$ITEM" drawing=off)
                    continue
                fi

                # Append description to icon field if set
                WS_NAME="${WS_NAMES[$sid]}"
                if [ -n "$WS_NAME" ]; then
                    [ ${#WS_NAME} -gt 15 ] && WS_NAME="${WS_NAME:0:12}..."
                    WS_ICON="$sid $WS_NAME "
                else
                    WS_ICON="$sid"
                fi

                if [ "$sid" = "$FOCUSED_WS" ]; then
                    CMD+=(--set "$ITEM" drawing=on
                        background.drawing=on background.color=0xffe1a860 background.border_color=0xffe1a860
                        icon="$WS_ICON" icon.color=0xff1e1e2e
                        label="$ICON_STRIP" label.color=0xff1e1e2e)
                else
                    CMD+=(--set "$ITEM" drawing=on
                        background.drawing=on background.color=0x00000000 background.border_color=0xffffffff
                        icon="$WS_ICON" icon.color=0xffffffff
                        label="$ICON_STRIP" label.color=0xffffffff)
                fi
            else
                CMD+=(--set "$ITEM" drawing=off)
            fi
        done
    done
done

sketchybar "${CMD[@]}" 2>/dev/null

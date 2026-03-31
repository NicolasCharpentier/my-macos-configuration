#!/usr/bin/env bash

# On system wake: reload sketchybar to recover from display/render issues.
# After sleep the bar can become invisible while the process is still alive.
if [ "$SENDER" = "system_woke" ]; then
    sleep 2  # let displays settle
    # If sketchybar is unresponsive, restart it entirely
    if ! sketchybar --query bar >/dev/null 2>&1; then
        killall -9 sketchybar 2>/dev/null
        sleep 1
        open -a sketchybar
    else
        sketchybar --reload
    fi
    exit 0
fi

# Reassign workspace items to the correct display on monitor change.

# Build mapping from DirectDisplayID -> arrangement-id using sketchybar
# (sketchybar's display= property expects arrangement-id, not DirectDisplayID)
declare -A DISPLAY_MAP
while IFS='|' read -r arr_id direct_id; do
    DISPLAY_MAP["$direct_id"]="$arr_id"
done < <(sketchybar --query displays 2>/dev/null \
    | python3 -c "import json,sys; [print(f'{d[\"arrangement-id\"]}|{d[\"DirectDisplayID\"]}') for d in json.load(sys.stdin)]")

# Update workspace display assignments
for monitor in $(aerospace list-monitors --format '%{monitor-id}'); do
    APPKIT_ID=$(aerospace list-monitors --format '%{monitor-id}|%{monitor-appkit-nsscreen-screens-id}' | grep "^${monitor}|" | cut -d'|' -f2)
    ARRANGEMENT_ID="${DISPLAY_MAP[$APPKIT_ID]:-$APPKIT_ID}"
    for sid in $(aerospace list-workspaces --monitor "$monitor"); do
        sketchybar --set space."$sid" display="$ARRANGEMENT_ID" 2>/dev/null
    done
done

# Trigger a workspace change update so items re-evaluate their state
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"

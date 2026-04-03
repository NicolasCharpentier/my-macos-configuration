#!/usr/bin/env bash

# On system wake: refresh the bar without a full --reload.
# Calling --reload from within a plugin can cause an infinite loop when the
# system_woke event is re-delivered to the freshly recreated item.
if [ "$SENDER" = "system_woke" ]; then
    # Prevent concurrent wake handlers
    LOCKFILE="/tmp/sketchybar_wake.lock"
    if [ -f "$LOCKFILE" ] && kill -0 "$(cat "$LOCKFILE" 2>/dev/null)" 2>/dev/null; then
        exit 0
    fi
    echo $$ > "$LOCKFILE"
    trap 'rm -f "$LOCKFILE"' EXIT

    sleep 2  # let displays settle

    # Nudge the bar to force a redraw (fixes invisible bar after sleep)
    sketchybar --bar y_offset=1
    sleep 0.2
    sketchybar --bar y_offset=0

    # Fall through to the display reassignment below
fi

# Reassign workspace items to the correct display on monitor change.

# Build mapping from DirectDisplayID -> arrangement-id using sketchybar
# (sketchybar's display= property expects arrangement-id, not DirectDisplayID)
declare -A DISPLAY_MAP
while IFS='|' read -r arr_id direct_id; do
    DISPLAY_MAP["$direct_id"]="$arr_id"
done < <(sketchybar --query displays 2>/dev/null \
    | python3 -c "import json,sys; [print(f'{d[\"arrangement-id\"]}|{d[\"DirectDisplayID\"]}') for d in json.load(sys.stdin)]")

# Trigger a workspace change update so items re-evaluate their state
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"

# Re-apply solid wallpaper after display change/wake
"$CONFIG_DIR/plugins/set_wallpaper.sh" &

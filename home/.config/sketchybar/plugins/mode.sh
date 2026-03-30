#!/usr/bin/env bash

if [ "$MODE" = "service" ]; then
    sketchybar --set '/unified\./' drawing=off \
               --set service.label drawing=on
else
    sketchybar --set service.label drawing=off \
               --set '/unified\.d.*\.mon\./' drawing=on \
               --set '/unified\.d.*\.sep\./' drawing=on
    # Let unified.sh restore workspace items
    FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
    sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"
fi

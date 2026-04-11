#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/timelog.sh"

printf -v now '%(%H:%M:%S)T' -1
sketchybar --set "$NAME" label="$now"

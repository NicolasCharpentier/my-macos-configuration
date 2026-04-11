#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/timelog.sh"

sketchybar --set "$NAME" label="$(date '+%a %d %b')"

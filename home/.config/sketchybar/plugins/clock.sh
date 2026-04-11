#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/timelog.sh"

sketchybar --set "$NAME" label="$(date '+%H:%M:%S')"

#!/usr/bin/env bash
# Single subscriber to mouse.exited.global — closes every popup in one
# batched sketchybar call. Replaces the per-item broadcast (36+ items each
# firing their own close handler) that caused the hover-freeze cascade.

source "$CONFIG_DIR/plugins/timelog.sh"

sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
           --set cpu.stats popup.drawing=off \
           --set ram.stats popup.drawing=off \
           --set docker.stats popup.drawing=off \
           --set ai.naming popup.drawing=off 2>/dev/null

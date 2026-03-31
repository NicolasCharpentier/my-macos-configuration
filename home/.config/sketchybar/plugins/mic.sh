#!/bin/sh

# Microphone mute toggle plugin
# On click: toggle mute/unmute (preserving original volume)
# On update: refresh icon to reflect current state

VOLUME_FILE="/tmp/sketchybar_mic_volume"

toggle_mic() {
  CURRENT=$(osascript -e "input volume of (get volume settings)")

  if [ "$CURRENT" -eq 0 ]; then
    # Unmute: restore saved volume
    if [ -f "$VOLUME_FILE" ]; then
      SAVED=$(cat "$VOLUME_FILE")
    else
      SAVED=50
    fi
    osascript -e "set volume input volume $SAVED"
  else
    # Mute: save current volume, then set to 0
    echo "$CURRENT" > "$VOLUME_FILE"
    osascript -e "set volume input volume 0"
  fi
}

if [ "$SENDER" = "mouse.clicked" ]; then
  toggle_mic
fi

# Update icon based on current state
CURRENT=$(osascript -e "input volume of (get volume settings)")

if [ "$CURRENT" -eq 0 ]; then
  ICON="󰍭"
  COLOR="0xffffb3b3"
else
  ICON="󰍬"
  COLOR="0xffffffff"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"

#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

sketchybar --set "$NAME" drawing=on

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="󰁹"
  ;;
  [6-8][0-9]) ICON="󰂁"
  ;;
  [3-5][0-9]) ICON="󰁾"
  ;;
  [1-2][0-9]) ICON="󰁻"
  ;;
  *) ICON="󰁺"
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󰂄"
fi

ICON_COLOR=0xff5a564f
if [ "$PERCENTAGE" -le 10 ] 2>/dev/null; then
  ICON_COLOR=0xffcc3333
elif [ "$PERCENTAGE" -le 20 ] 2>/dev/null; then
  ICON_COLOR=0xffdd8844
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" label="${PERCENTAGE}%"

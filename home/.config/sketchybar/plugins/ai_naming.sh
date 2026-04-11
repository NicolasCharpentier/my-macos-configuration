#!/usr/bin/env bash
# AI naming control panel: icon state + click popup

source "$CONFIG_DIR/plugins/timelog.sh"

ENABLED_FILE="$HOME/.cache/workspace-summarizer/enabled"
COST_SESSION="$HOME/.cache/workspace-summarizer/cost.session"
COST_TOTAL="$HOME/.cache/workspace-summarizer/cost.total"
TOKENS_SESSION="$HOME/.cache/workspace-summarizer/tokens.session"
TOKENS_TOTAL="$HOME/.cache/workspace-summarizer/tokens.total"

# On ai_naming_changed event or initial load: update icon
if [ "$SENDER" != "mouse.clicked" ]; then
    if [ -f "$ENABLED_FILE" ]; then
        sketchybar --set "$NAME" icon="󰯂" icon.color=0xffffffff
    else
        sketchybar --set "$NAME" icon="󰯃" icon.color=0xffffb3b3
    fi
    exit 0
fi

# On click: toggle popup
POPUP_STATE=$(sketchybar --query "$NAME" 2>/dev/null \
    | python3 -c "import json,sys; print(json.load(sys.stdin).get('popup',{}).get('drawing','off'))" 2>/dev/null)

if [ "$POPUP_STATE" = "on" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
fi

# Close all other popups
sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
           --set cpu.stats popup.drawing=off \
           --set ram.stats popup.drawing=off \
           --set docker.stats popup.drawing=off \
           --set ai.naming popup.drawing=off 2>/dev/null

# Remove old popup items
sketchybar --remove '/ai\.naming\.popup\..*/' 2>/dev/null

# Determine state
IS_ENABLED=false
[ -f "$ENABLED_FILE" ] && IS_ENABLED=true

# Format costs (4 decimal places) and tokens (integer)
RAW_SESS_COST=$(cat "$COST_SESSION" 2>/dev/null || echo "0")
RAW_TOTAL_COST=$(cat "$COST_TOTAL" 2>/dev/null || echo "0")
RAW_SESS_TOKENS=$(cat "$TOKENS_SESSION" 2>/dev/null || echo "0")
RAW_TOTAL_TOKENS=$(cat "$TOKENS_TOTAL" 2>/dev/null || echo "0")

SESS_COST=$(printf "%.4f" "$RAW_SESS_COST")
TOTAL_COST=$(printf "%.4f" "$RAW_TOTAL_COST")
SESS_TOKENS=$(printf "%.0f" "$RAW_SESS_TOKENS")
TOTAL_TOKENS=$(printf "%.0f" "$RAW_TOTAL_TOKENS")

IDX=0

# --- Toggle enable/disable ---
if [ "$IS_ENABLED" = true ]; then
    TOGGLE_LABEL="Disable AI Naming"
    TOGGLE_ICON="󰯃"
    TOGGLE_COLOR=0xffffb3b3
else
    TOGGLE_LABEL="Enable AI Naming"
    TOGGLE_ICON="󰯂"
    TOGGLE_COLOR=0xffffffff
fi

sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="$TOGGLE_ICON" icon.font="Hack Nerd Font:Bold:14.0" icon.color="$TOGGLE_COLOR" \
        label="$TOGGLE_LABEL" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffffff \
        click_script="$CONFIG_DIR/plugins/ai_naming_toggle.sh"
IDX=$((IDX + 1))

# --- Separator ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="─" icon.font="Hack Nerd Font:Regular:8.0" icon.color=0xff555555 \
        label="─────────────" label.font="Hack Nerd Font:Regular:8.0" label.color=0xff555555
IDX=$((IDX + 1))

# --- Session cost + tokens ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="󰄘" icon.font="Hack Nerd Font:Bold:14.0" icon.color=0xffaaaaaa \
        label="Sess.: \$${SESS_COST} / ${SESS_TOKENS} tokens" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffffff
IDX=$((IDX + 1))

# --- Total cost + tokens ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="󰄘" icon.font="Hack Nerd Font:Bold:14.0" icon.color=0xffaaaaaa \
        label="Total: \$${TOTAL_COST} / ${TOTAL_TOKENS} tokens" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffffff
IDX=$((IDX + 1))

# --- Reset session cost ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="󰜺" icon.font="Hack Nerd Font:Bold:14.0" icon.color=0xffaaaaaa \
        label="Reset Session Cost" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffffff \
        click_script="$CONFIG_DIR/plugins/ai_naming_clear.sh cost-session"
IDX=$((IDX + 1))

# --- Reset all costs ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="󰜺" icon.font="Hack Nerd Font:Bold:14.0" icon.color=0xffaaaaaa \
        label="Reset All Costs" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffffff \
        click_script="$CONFIG_DIR/plugins/ai_naming_clear.sh cost-all"
IDX=$((IDX + 1))

# --- Separator ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="─" icon.font="Hack Nerd Font:Regular:8.0" icon.color=0xff555555 \
        label="─────────────" label.font="Hack Nerd Font:Regular:8.0" label.color=0xff555555
IDX=$((IDX + 1))

# --- Clear AI names ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="󰃢" icon.font="Hack Nerd Font:Bold:14.0" icon.color=0xffaaaaaa \
        label="Clear AI Names" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffffff \
        click_script="$CONFIG_DIR/plugins/ai_naming_clear.sh ai"
IDX=$((IDX + 1))

# --- Clear all names (red-tinted) ---
sketchybar --add item "ai.naming.popup.$IDX" popup."$NAME" \
    --set "ai.naming.popup.$IDX" \
        icon="󰃢" icon.font="Hack Nerd Font:Bold:14.0" icon.color=0xffffb3b3 \
        label="Clear All Names" label.font="Hack Nerd Font:Regular:13.0" label.color=0xffffb3b3 \
        click_script="$CONFIG_DIR/plugins/ai_naming_clear.sh all"
IDX=$((IDX + 1))

sketchybar --set "$NAME" popup.drawing=on

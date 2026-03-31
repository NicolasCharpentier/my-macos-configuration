#!/usr/bin/env bash

if [ "$SENDER" = "system_stats" ]; then
    sketchybar --set cpu.stats label="CPU $CPU_USAGE" \
               --set ram.stats label="RAM $RAM_USAGE"

    # Store values for popup use via cached env file
    cat > /tmp/sketchybar_stats_cache <<CACHE
CPU_USAGE="$CPU_USAGE"
CPU_TEMP="$CPU_TEMP"
RAM_USAGE="$RAM_USAGE"
RAM_USED="$RAM_USED"
RAM_TOTAL="$RAM_TOTAL"
SWP_USAGE="$SWP_USAGE"
SWP_USED="$SWP_USED"
SWP_TOTAL="$SWP_TOTAL"
DISK_USAGE="$DISK_USAGE"
DISK_USED="$DISK_USED"
DISK_FREE="$DISK_FREE"
DISK_TOTAL="$DISK_TOTAL"
UPTIME="$UPTIME"
CACHE
    exit 0
fi

if [ "$SENDER" = "mouse.entered" ]; then
    # Close all other popups first (workspace + stats)
    sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
               --set cpu.stats popup.drawing=off \
               --set ram.stats popup.drawing=off 2>/dev/null

    source /tmp/sketchybar_stats_cache 2>/dev/null

    # Remove old popup items
    ESCAPED=$(echo "$NAME" | sed 's/\./\\./g')
    sketchybar --remove "/${ESCAPED}\.popup\..*/" 2>/dev/null

    ITEMS=()
    if [ "$NAME" = "cpu.stats" ]; then
        ITEMS+=("CPU|$CPU_USAGE")
        [ -n "$CPU_TEMP" ] && ITEMS+=("Temp|$CPU_TEMP")
        ITEMS+=("RAM|$RAM_USED / $RAM_TOTAL")
        [ -n "$SWP_USAGE" ] && [ "$SWP_USAGE" != "0%" ] && ITEMS+=("Swap|$SWP_USED / $SWP_TOTAL")
    elif [ "$NAME" = "ram.stats" ]; then
        ITEMS+=("RAM|$RAM_USED / $RAM_TOTAL ($RAM_USAGE)")
        [ -n "$SWP_USAGE" ] && [ "$SWP_USAGE" != "0%" ] && ITEMS+=("Swap|$SWP_USED / $SWP_TOTAL ($SWP_USAGE)")
    fi

    # Top processes (fetched live on hover)
    if [ "$NAME" = "cpu.stats" ]; then
        ITEMS+=("─|─────────────")
        while IFS= read -r line; do
            pct=$(echo "$line" | awk '{print $1"%"}')
            cmd=$(echo "$line" | awk '{for(i=2;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//' | cut -c1-20)
            ITEMS+=("$cmd|$pct")
        done < <(ps -arcwwxo "%cpu,comm" | tail -n +2 | head -5)
    elif [ "$NAME" = "ram.stats" ]; then
        ITEMS+=("─|─────────────")
        while IFS= read -r line; do
            pct=$(echo "$line" | awk '{print $1"%"}')
            cmd=$(echo "$line" | awk '{for(i=2;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//' | cut -c1-20)
            ITEMS+=("$cmd|$pct")
        done < <(ps -amwwxo "%mem,comm" | tail -n +2 | head -5)
    fi

    # Common items in both popups
    ITEMS+=("─|─────────────")
    ITEMS+=("Disk|$DISK_USED / $DISK_TOTAL ($DISK_USAGE)")
    [ -n "$UPTIME" ] && ITEMS+=("Up|$UPTIME")

    IDX=0
    for entry in "${ITEMS[@]}"; do
        IFS='|' read -r lbl val <<< "$entry"
        ITEM="$NAME.popup.$IDX"
        if [ "$lbl" = "─" ]; then
            sketchybar --add item "$ITEM" popup."$NAME" \
                --set "$ITEM" \
                    icon="$lbl" \
                    icon.font="Hack Nerd Font:Regular:8.0" \
                    icon.color=0xff555555 \
                    label="$val" \
                    label.font="Hack Nerd Font:Regular:8.0" \
                    label.color=0xff555555
        else
            sketchybar --add item "$ITEM" popup."$NAME" \
                --set "$ITEM" \
                    icon="$lbl" \
                    icon.font="Hack Nerd Font:Bold:12.0" \
                    icon.color=0xffaaaaaa \
                    icon.padding_right=8 \
                    label="$val" \
                    label.font="Hack Nerd Font:Regular:12.0" \
                    label.color=0xffffffff
        fi
        IDX=$((IDX + 1))
    done

    sketchybar --set "$NAME" popup.drawing=on

    # Auto-hide popup after 5 seconds
    PIDFILE="/tmp/sketchybar_popup_${NAME}.pid"
    kill "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null
    (sleep 5 && sketchybar --set "$NAME" popup.drawing=off) &
    echo $! > "$PIDFILE"

    exit 0
fi

if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    kill "$(cat "/tmp/sketchybar_popup_${NAME}.pid" 2>/dev/null)" 2>/dev/null
    exit 0
fi

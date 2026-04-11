#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/timelog.sh"

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
    # Close all other popups first (workspace + stats + ai naming)
    sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
               --set cpu.stats popup.drawing=off \
               --set ram.stats popup.drawing=off \
               --set docker.stats popup.drawing=off \
               --set ai.naming popup.drawing=off 2>/dev/null

    source /tmp/sketchybar_stats_cache 2>/dev/null

    ITEMS=()
    if [ "$NAME" = "cpu.stats" ]; then
        ITEMS+=("§|CPU")
        ITEMS+=("CPU|$CPU_USAGE")
        [ -n "$CPU_TEMP" ] && ITEMS+=("Temp|$CPU_TEMP")
    elif [ "$NAME" = "ram.stats" ]; then
        ITEMS+=("§|MEMORY")
        ITEMS+=("RAM|$RAM_USED / $RAM_TOTAL ($RAM_USAGE)")
        [ -n "$SWP_USAGE" ] && [ "$SWP_USAGE" != "0%" ] && ITEMS+=("Swap|$SWP_USED / $SWP_TOTAL ($SWP_USAGE)")
    fi

    # Top processes (fetched live on hover)
    if [ "$NAME" = "cpu.stats" ]; then
        CORES=$(sysctl -n hw.ncpu)
        ITEMS+=("─|")
        ITEMS+=("§|TOP PROCESSES")
        while IFS= read -r line; do
            raw=$(echo "$line" | awk '{print $1}')
            cmd=$(echo "$line" | awk '{for(i=2;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//')
            cmd="${cmd##*/}"
            total=$(awk -v r="$raw" -v c="$CORES" 'BEGIN { printf "%.1f", r/c }')
            ITEMS+=("$cmd (${raw}% per core)|${total}%")
        done < <(ps -arcwwxo "%cpu,comm" | tail -n +2 | head -8)
    elif [ "$NAME" = "ram.stats" ]; then
        ITEMS+=("─|")
        ITEMS+=("§|TOP PROCESSES")
        while IFS= read -r line; do
            pct=$(echo "$line" | awk '{print $1}')
            kb=$(echo "$line" | awk '{print $2}')
            cmd=$(echo "$line" | awk '{for(i=3;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//')
            cmd="${cmd##*/}"
            if [ "$kb" -lt 1024 ]; then
                mem="${kb} KB"
            elif [ "$kb" -lt 1048576 ]; then
                mem="$((kb / 1024)) MB"
            else
                mem=$(awk -v k="$kb" 'BEGIN { printf "%.1f GB", k/1048576 }')
            fi
            ITEMS+=("$cmd (${pct}%)|$mem")
        done < <(ps -amwwxo "%mem,rss,comm" | tail -n +2 | head -8)
    fi

    # Load average (CPU dropdown only) — expressed as total CPU% (load × 100 / cores)
    if [ "$NAME" = "cpu.stats" ]; then
        ITEMS+=("─|")
        ITEMS+=("§|LOAD AVERAGE")
        read -r l1 l5 l15 < <(sysctl -n vm.loadavg | awk '{print $2, $3, $4}')
        p1=$(awk -v l="$l1"  -v c="$CORES" 'BEGIN { printf "%.0f", l*100/c }')
        p5=$(awk -v l="$l5"  -v c="$CORES" 'BEGIN { printf "%.0f", l*100/c }')
        p15=$(awk -v l="$l15" -v c="$CORES" 'BEGIN { printf "%.0f", l*100/c }')
        ITEMS+=("last minute|${p1}%")
        ITEMS+=("last 5 minutes|${p5}%")
        ITEMS+=("last 15 minutes|${p15}%")
    fi

    # Common items in both popups
    ITEMS+=("─|")
    ITEMS+=("§|SYSTEM")
    ITEMS+=("Disk|$DISK_USED / $DISK_TOTAL ($DISK_USAGE)")
    [ -n "$UPTIME" ] && ITEMS+=("Up|$UPTIME")

    # Update pre-created slots (no --add / --remove)
    ARGS=()
    SLOT=0
    for entry in "${ITEMS[@]}"; do
        IFS='|' read -r lbl val <<< "$entry"
        if [ "$lbl" = "─" ]; then
            ARGS+=(--set "$NAME.slot.$SLOT"
                       drawing=on
                       icon.drawing=off
                       label.drawing=on
                       "label=──────────────────────────────────────────────────"
                       "label.font=Hack Nerd Font:Regular:10.0"
                       label.color=0xffc8c3bb
                       label.padding_left=0
                       label.padding_right=0)
        elif [ "$lbl" = "§" ]; then
            ARGS+=(--set "$NAME.slot.$SLOT"
                       drawing=on
                       icon.drawing=off
                       label.drawing=on
                       "label=$val"
                       "label.font=Hack Nerd Font:Bold:10.0"
                       label.color=0xff9a958d
                       label.padding_left=0)
        else
            ARGS+=(--set "$NAME.slot.$SLOT"
                       drawing=on
                       icon.drawing=on
                       label.drawing=on
                       "icon=$val"
                       "icon.font=Hack Nerd Font:Bold:12.0"
                       icon.color=0xff3a3630
                       icon.padding_right=8
                       "label=$lbl"
                       "label.font=Hack Nerd Font:Regular:12.0"
                       label.color=0xff5a564f)
        fi
        SLOT=$((SLOT + 1))
    done

    # Hide unused slots
    while [ "$SLOT" -lt 25 ]; do
        ARGS+=(--set "$NAME.slot.$SLOT" drawing=off)
        SLOT=$((SLOT + 1))
    done

    sketchybar "${ARGS[@]}"

    sketchybar --set "$NAME" popup.drawing=on

    # Auto-hide popup after 5 seconds
    PIDFILE="/tmp/sketchybar_popup_${NAME}.pid"
    kill "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null
    (sleep 10 && sketchybar --set "$NAME" popup.drawing=off) &
    echo $! > "$PIDFILE"

    exit 0
fi

if [ "$SENDER" = "mouse.exited" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    kill "$(cat "/tmp/sketchybar_popup_${NAME}.pid" 2>/dev/null)" 2>/dev/null
    exit 0
fi

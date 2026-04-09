#!/usr/bin/env bash

DOCKER=/usr/local/bin/docker
CACHE=/tmp/sketchybar_docker_cache
SLOT_COUNT=30

# Periodic update: check Docker status, count containers, cache container list
if [ "$SENDER" = "routine" ] || [ "$SENDER" = "forced" ] || [ -z "$SENDER" ]; then
    CONTAINERS=$($DOCKER ps --format '{{.Names}}\t{{.Ports}}' 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$CONTAINERS" ]; then
        # Docker not running or no containers
        if ! $DOCKER info &>/dev/null; then
            sketchybar --set "$NAME" label="off" icon.color=0xff9a958d label.color=0xff9a958d
            printf 'DOCKER_RUNNING=false\n' > "$CACHE"
            exit 0
        fi
        # Docker running but zero containers
        sketchybar --set "$NAME" label="0" icon.color=0xff5a564f label.color=0xff5a564f
        printf 'DOCKER_RUNNING=true\nDOCKER_COUNT=0\nDOCKER_LINES=\n' > "$CACHE"
        exit 0
    fi

    COUNT=$(echo "$CONTAINERS" | wc -l | tr -d ' ')
    sketchybar --set "$NAME" label="$COUNT" icon.color=0xff5a564f label.color=0xff5a564f

    # Pre-compute sorted popup lines: name|ports (host-mapped only)
    SORTED=$(echo "$CONTAINERS" | sort -t$'\t' -k1,1 | awk -F'\t' '
    {
        name = $1; raw = $2; result = ""
        n = split(raw, parts, ",")
        for (i = 1; i <= n; i++) {
            if (match(parts[i], /0\.0\.0\.0:[0-9]+/)) {
                port = substr(parts[i], RSTART + 8, RLENGTH - 8)
                if (result != "") result = result " "
                result = result ":" port
            }
        }
        print name "|" result
    }')

    {
        printf 'DOCKER_RUNNING=true\n'
        printf 'DOCKER_COUNT=%s\n' "$COUNT"
        printf 'DOCKER_LINES=%s\n' "$(echo "$SORTED" | base64)"
    } > "$CACHE"

    exit 0
fi

if [ "$SENDER" = "mouse.entered" ]; then
    # Close all other popups
    sketchybar --set '/unified\.d.*\.ws\..*/' popup.drawing=off \
               --set cpu.stats popup.drawing=off \
               --set ram.stats popup.drawing=off \
               --set docker.stats popup.drawing=off \
               --set ai.naming popup.drawing=off 2>/dev/null

    source "$CACHE" 2>/dev/null

    ARGS=()
    SLOT=0

    if [ "$DOCKER_RUNNING" != "true" ]; then
        ARGS+=(--set "$NAME.slot.0"
                   drawing=on
                   icon.drawing=off
                   label.drawing=on
                   "label=Docker is not running"
                   "label.font=Hack Nerd Font:Regular:12.0"
                   label.color=0xff9a958d
                   label.padding_left=0)
        SLOT=1
    elif [ "$DOCKER_COUNT" = "0" ]; then
        ARGS+=(--set "$NAME.slot.0"
                   drawing=on
                   icon.drawing=off
                   label.drawing=on
                   "label=No containers running"
                   "label.font=Hack Nerd Font:Regular:12.0"
                   label.color=0xff9a958d
                   label.padding_left=0)
        SLOT=1
    else
        LINES=$(echo "$DOCKER_LINES" | base64 -d 2>/dev/null)
        while IFS='|' read -r cname ports; do
            [ -z "$cname" ] && continue

            # Determine color: gray for infrastructure containers
            LCOLOR=0xff5a564f
            ICOLOR=0xff3a3630
            case "$cname" in
                *-database*|*-mailcatcher*|*-nginx*|*-meilisearch*) LCOLOR=0xff9a958d; ICOLOR=0xff9a958d ;;
            esac

            ARGS+=(--set "$NAME.slot.$SLOT"
                       drawing=on
                       icon.drawing=on
                       label.drawing=on
                       "icon=$cname"
                       "icon.font=Hack Nerd Font:Regular:12.0"
                       "icon.color=$LCOLOR"
                       icon.padding_right=8
                       "label=$ports"
                       "label.font=Hack Nerd Font:Bold:12.0"
                       "label.color=$ICOLOR")
            SLOT=$((SLOT + 1))
        done <<< "$LINES"
    fi

    # Hide unused slots
    while [ "$SLOT" -lt "$SLOT_COUNT" ]; do
        ARGS+=(--set "$NAME.slot.$SLOT" drawing=off)
        SLOT=$((SLOT + 1))
    done

    sketchybar "${ARGS[@]}"
    sketchybar --set "$NAME" popup.drawing=on

    # Auto-hide after 10 seconds
    PIDFILE="/tmp/sketchybar_popup_${NAME}.pid"
    kill "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null
    (sleep 10 && sketchybar --set "$NAME" popup.drawing=off) &
    echo $! > "$PIDFILE"

    exit 0
fi

if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    kill "$(cat "/tmp/sketchybar_popup_${NAME}.pid" 2>/dev/null)" 2>/dev/null
    exit 0
fi

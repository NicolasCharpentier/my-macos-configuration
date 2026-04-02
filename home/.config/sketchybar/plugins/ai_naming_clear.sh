#!/usr/bin/env bash
# Clear workspace names or reset cost counters
# Usage: ai_naming_clear.sh [ai|all|cost-session|cost-all]

MODE="$1"
SUMMARIES="$HOME/.cache/workspace-summarizer/summaries.haiku"
HASH_FILE="$HOME/.cache/workspace-summarizer/windows.hash"
NAMES_FILE="$HOME/.config/aerospace/workspace-names"
COST_SESSION="$HOME/.cache/workspace-summarizer/cost.session"
COST_TOTAL="$HOME/.cache/workspace-summarizer/cost.total"
TOKENS_SESSION="$HOME/.cache/workspace-summarizer/tokens.session"
TOKENS_TOTAL="$HOME/.cache/workspace-summarizer/tokens.total"

case "$MODE" in
    ai)
        rm -f "$SUMMARIES" "$HASH_FILE"
        ;;
    all)
        rm -f "$SUMMARIES" "$HASH_FILE"
        > "$NAMES_FILE"
        ;;
    cost-session)
        echo "0" > "$COST_SESSION"
        echo "0" > "$TOKENS_SESSION"
        ;;
    cost-all)
        echo "0" > "$COST_SESSION"
        echo "0" > "$COST_TOTAL"
        echo "0" > "$TOKENS_SESSION"
        echo "0" > "$TOKENS_TOTAL"
        ;;
esac

# Close popup and refresh
sketchybar --set ai.naming popup.drawing=off
sketchybar --trigger ai_naming_changed 2>/dev/null
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"

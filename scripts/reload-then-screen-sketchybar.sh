#!/bin/bash

# Reload sketchybar, wait 5s for items to stabilize, then rotate screenshots:
# current -> p1, p1 -> p2, and capture a fresh screenshot of the bar.
#
# To display images live in the terminal (kitty):
#
# Previous previous image (p2):
#   chafa -f kitty --scale max --clear /tmp/topbar_p2.png
#   fswatch -o /tmp/topbar_p2.png | while read; do chafa -f kitty --scale max --clear /tmp/topbar_p2.png; done
#
# Previous image (p1):
#   chafa -f kitty --scale max --clear /tmp/topbar_p1.png
#   fswatch -o /tmp/topbar_p1.png | while read; do chafa -f kitty --scale max --clear /tmp/topbar_p1.png; done
#
# Latest image (most recent):
#   chafa -f kitty --scale max --clear /tmp/topbar_current.png
#   fswatch -o /tmp/topbar_current.png | while read; do chafa -f kitty --scale max --clear /tmp/topbar_current.png; done

sketchybar --reload && sleep 5 && mv -f /tmp/topbar_p1.png /tmp/topbar_p2.png 2>/dev/null; mv -f /tmp/topbar_current.png /tmp/topbar_p1.png 2>/dev/null; screencapture -x -R 0,0,900,60 /tmp/topbar_current.png 2>&1

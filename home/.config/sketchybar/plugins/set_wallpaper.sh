#!/usr/bin/env bash

WALLPAPER="$HOME/.config/sketchybar/assets/wallpaper.png"
[ ! -f "$WALLPAPER" ] && exit 1

# Use NSWorkspace API via swift (no Apple Events permission needed)
swift - "$WALLPAPER" <<'SWIFT' 2>/dev/null
import Cocoa
let path = CommandLine.arguments[1]
let url = URL(fileURLWithPath: path)
for screen in NSScreen.screens {
    try? NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
}
SWIFT

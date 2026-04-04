#!/usr/bin/env bash

# Usage: set_wallpaper.sh <hex_color>
# Example: set_wallpaper.sh f8f7f5

COLOR="${1:?Usage: set_wallpaper.sh <hex_color>}"
COLOR="${COLOR#\#}" # strip leading # if present

CACHE_DIR="/tmp/sketchybar-wallpaper"
mkdir -p "$CACHE_DIR"
rm -f "$CACHE_DIR"/wallpaper-*.png
STAMPED="$CACHE_DIR/wallpaper-$$.png"

python3 -c "
import struct, zlib, sys
c = sys.argv[1]
r, g, b = int(c[0:2],16), int(c[2:4],16), int(c[4:6],16)
W, H = 64, 64
sig = b'\x89PNG\r\n\x1a\n'
def chunk(t, d):
    x = t + d
    return struct.pack('>I', len(d)) + x + struct.pack('>I', zlib.crc32(x) & 0xffffffff)
ihdr = struct.pack('>IIBBBBB', W, H, 8, 2, 0, 0, 0)
raw = (b'\x00' + bytes([r,g,b]) * W) * H
with open(sys.argv[2], 'wb') as f:
    f.write(sig + chunk(b'IHDR', ihdr) + chunk(b'IDAT', zlib.compress(raw)) + chunk(b'IEND', b''))
" "$COLOR" "$STAMPED"

swift -e '
import AppKit
let url = URL(fileURLWithPath: CommandLine.arguments[1])
for screen in NSScreen.screens {
    try? NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
}
' "$STAMPED" 2>/dev/null
sleep 2

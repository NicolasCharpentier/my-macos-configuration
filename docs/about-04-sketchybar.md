# SketchyBar

Highly customizable macOS status bar replacement, written in C. [GitHub](https://github.com/FelixKratz/SketchyBar)

## Why

The native macOS menu bar is rigid and wastes space showing things you don't need. With a tiling WM setup (AeroSpace + JankyBorders), having a bar that shows workspace indicators, the focused app, clock, and battery — all event-driven and scriptable — completes the workflow.

SketchyBar is the standard companion to AeroSpace in the macOS ricing community. It's GPL-3.0, makes zero network requests, has no telemetry, and is extremely lightweight (C + event-driven architecture = near-zero idle CPU).

## Install

```bash
brew tap FelixKratz/formulae
brew install sketchybar
brew install --cask font-hack-nerd-font
brew tap joncrangle/tap
brew install sketchybar-system-stats
```

[sketchybar-system-stats](https://github.com/joncrangle/sketchybar-system-stats) is a lightweight Rust binary that feeds CPU, RAM, disk, temperature and other system metrics to SketchyBar via a custom event. It runs as a background daemon launched from `sketchybarrc`.

Optionally hide the native menu bar: System Settings > Control Center > "Automatically hide and show the menu bar" > "Always".

## Config

Lives in `~/.config/sketchybar/sketchybarrc` (a shell script, not a static config). Plugin scripts live in `~/.config/sketchybar/plugins/`.

Started automatically by AeroSpace via `after-startup-command` — no need for `brew services start`.

### AeroSpace integration

AeroSpace notifies SketchyBar on every workspace change via `exec-on-workspace-change`. The workspace items in the bar highlight the focused workspace and are clickable to switch.

### Current items

- **Left:** workspace indicators (1-9), highlighted on focus, clickable
- **Center:** active app name
- **Right:** clock (dd/mm HH:MM), battery with icon + percentage

### Gaps between bracket tabs

Creating visible gaps between bracket-backed tabs is not straightforward:

- **`background.padding_left/right` on brackets** does NOT shrink the bracket background when set to negative values. Positive values extend it but brackets still touch.
- **Increasing `padding_left/right` on items inside a bracket** makes the bracket bigger, not the gap — the bracket covers member items including their padding.

The only reliable method is to **add spacer items between tabs** that are not part of any bracket:

```bash
sketchybar --add item spacer_name left \
    --set spacer_name \
        drawing=off \
        icon.drawing=off \
        label.drawing=off \
        background.drawing=off \
        padding_left=0 \
        padding_right=0 \
        width=4
```

Then toggle `drawing=on/off` in the update script alongside the tabs they separate. The `width` property controls the gap size in pixels.

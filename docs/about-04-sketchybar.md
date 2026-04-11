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

## Debugging: error logs

When installed via Homebrew, sketchybar runs under `launchd` via `~/Library/LaunchAgents/homebrew.mxcl.sketchybar.plist`. The plist redirects stdout and stderr to log files:

- **stderr:** `/opt/homebrew/var/log/sketchybar/sketchybar.err.log`
- **stdout:** `/opt/homebrew/var/log/sketchybar/sketchybar.out.log`

Plugin scripts inherit those file descriptors, so **every error from a plugin (e.g. `unified.sh`, `stats.sh`) lands in `sketchybar.err.log`** — syntax errors, missing binaries, failed commands, python tracebacks, everything.

This is invaluable for debugging plugins that seem to "mostly work" but silently skip branches. For instance, if a plugin uses bash 4+ features (`declare -A`, `mapfile`, `**` globstar) and the shebang resolves to macOS's stock bash 3.2, the errors accumulate here while the bar keeps limping along. See [about-09-bash.md](about-09-bash.md).

Useful commands:

```bash
# Live tail while debugging
tail -f /opt/homebrew/var/log/sketchybar/sketchybar.err.log

# Truncate without breaking launchd's file handle (don't `rm`)
: > /opt/homebrew/var/log/sketchybar/sketchybar.err.log

# Size check — a healthy log should be small
wc -l /opt/homebrew/var/log/sketchybar/sketchybar.err.log
```

Pattern: truncate the log, restart sketchybar (`brew services restart sketchybar`), trigger the behavior, then read what landed in the log. Much faster than adding `echo`s and wondering where they go.

## Performance profiling: timelog

`plugins/timelog.sh` is an opt-in profiler that instruments every `aerospace` and `sketchybar` call made from plugin scripts. It's sourced by `sketchybarrc` and every plugin that talks to those binaries, but **disabled by default via a `return 0` at the top of the file**. Comment out that line to enable; revert when done.

When enabled, it defines shadow shell functions `aerospace()` and `sketchybar()` that wrap the real binaries via `command`, measure wall time with bash 5's `$EPOCHREALTIME` builtin (zero subprocess overhead), and append one line per call to `/tmp/sketchybar-timelog.log`:

```
[   12ms] unified.sh           aerospace list-windows --all --format %{workspace}|%{app-name}
[    5ms] unified.sh           sketchybar --set unified.d1.mon.1 drawing=on label=S34J5 ...
```

Subshells inherit the functions, so `X=$(aerospace ...)` is also captured. Instrumentation overhead per wrapped call is under 0.1ms — far below the signal you're trying to measure.

### Usage

```bash
# 1. Enable: comment the `return 0` line in plugins/timelog.sh
# 2. Reset the log and restart sketchybar
: > /tmp/sketchybar-timelog.log
brew services restart sketchybar

# 3. Trigger the behavior (alt-tab, hover, etc.) and watch
tail -f /tmp/sketchybar-timelog.log

# 4. When done: uncomment `return 0` so plugins stop logging
```

### Why this design

- **Shadow functions, not call-site wrapping**: zero edits to the 100+ existing call sites. `source timelog.sh` at the top of each plugin is enough.
- **Bash 5 required**: `$EPOCHREALTIME` is the only way to timestamp without spawning a subprocess. Any shell-based timing on bash 3.2 (`gdate`, `perl`, `python3`) adds 5–40ms per wrapped call and corrupts the measurement. macOS ships bash 3.2 as `/bin/sh`, so plugins use `#!/usr/bin/env bash` and rely on Homebrew bash being first in PATH. See [about-09-bash.md](about-09-bash.md).
- **Disabled by default in committed form**: the `source` lines stay in every plugin so enabling is one-line toggle, but instrumentation itself is off in steady state — no log file growth, no runtime cost.

### Key lessons learned from profiling this bar

- **Sketchybar serializes calls under load.** Steady-state `--set` runs in 3–10ms, but when many plugins hammer the socket simultaneously, each call can block ~110ms waiting in queue. Fewer calls beats faster calls.
- **`mouse.exited.global` is a broadcast event.** Every item subscribed to it runs its handler when *any* popup closes anywhere. If 36 items subscribe, one bar-exit fires 36 handlers. Only one invisible controller item should subscribe; see `plugins/popup_close_all.sh`.
- **Dead code still costs subprocess time.** A bash variable assigned but never read still spawns the aerospace subprocess in the command substitution.
- **Batch with `--all` instead of looping.** `aerospace list-windows --all --format '%{workspace}|%{app-name}'` replaces a 9-iteration loop of `list-windows --workspace N` calls. One subprocess instead of nine.
- **Startup ≠ steady-state.** The first ~1 second after `brew services restart` has every call at ~100ms because CGS window server is settling. Don't benchmark against startup traces.
- **Event re-triggering loops double work.** If plugin A fires `sketchybar --trigger X` and plugin B is also subscribed to X, the same downstream handler runs twice per event. Grep for `--trigger` whenever adding a new handler.

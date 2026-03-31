# System Stats (sketchybar-system-stats)

Lightweight Rust binary that feeds CPU and RAM usage to SketchyBar via a custom event. [GitHub](https://github.com/joncrangle/sketchybar-system-stats)

## Why

Polling system stats with shell scripts (top, ps, vm_stat) is wasteful and inaccurate. `stats_provider` is a single compiled binary that efficiently reads system metrics and pushes them to SketchyBar's event system every N seconds — no shell overhead, no parsing hacks.

## Install

```bash
brew tap joncrangle/tap
brew install sketchybar-system-stats
```

## How it works

`stats_provider` runs as a background daemon, launched from `sketchybarrc`:

```bash
stats_provider --cpu usage --memory ram_usage --interval 5 &
```

Every 5 seconds it triggers a `system_stats` event with environment variables (`$CPU_USAGE`, `$RAM_USAGE`). SketchyBar items subscribe to this event and update their labels from the env vars.

## Current usage

Two items on the right side of the bar showing CPU % and RAM % as text, between battery and the clock/date group.

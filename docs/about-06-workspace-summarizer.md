# Workspace Summarizer

AI-powered workspace naming using Claude CLI (Haiku). Generates short unique summaries for each workspace based on open windows. Manual names always take priority over AI-generated ones.

## Installation

Requires the [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) (`claude` command) with access to Haiku model, and `jq` for JSON parsing.

## How it works

1. AI naming is **disabled on startup** — enable it via the brain icon in sketchybar's right side
2. Once enabled, aerospace hooks (`exec-on-workspace-change`, `on-focus-changed`, `on-window-detected`) trigger a debounce script
3. After 5 seconds of inactivity, the summarizer runs
4. It gathers windows (skipping manually-named workspaces), hashes for change detection
5. Calls Claude Haiku with `--output-format json` to get summaries and cost data
6. AI names appear inline in workspace items alongside manual names (manual wins)

## Sketchybar control panel

Click the brain icon (right side of bar) to:
- **Enable/Disable** AI naming (immediate generation on enable)
- **View costs** — session and all-time cumulative
- **Reset costs** — session only or all
- **Clear AI names** — removes AI-generated names, keeps manual
- **Clear all names** — removes both AI and manual names

## Manual naming

Click any workspace item to open a rename dialog. Manual names:
- Override AI names for that workspace
- Prevent AI from generating names for that workspace
- Clearing a manual name (empty input) triggers AI regeneration if enabled

## Editing the prompt

The prompt is in `~/.config/workspace-summarizer/prompt.txt`. Edit it freely — the summarizer reads it on every run.

## Cache files

All state lives in `~/.cache/workspace-summarizer/`:

- `enabled` — presence = AI on, absence = AI off
- `summaries.haiku` — current AI summaries (format: `workspace_id|summary`)
- `cost.session` — session cost in USD (reset on aerospace startup)
- `cost.total` — all-time cost in USD
- `windows` — window snapshot from last generation
- `windows.hash` — hash for change detection

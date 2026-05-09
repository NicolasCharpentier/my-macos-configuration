# Spotspaces

Companion overlay for AeroSpace. Shows the workspace map / mode-help when LEFT-ALT is held or a binding mode is active, and provides an app-pinning registry that auto-routes known apps to their preferred workspace.

**Private package** — only available on my own machines (source: `~/Projets/Spotspaces`).

## Why

AeroSpace is keyboard-driven and headless: there's no on-screen feedback for "which workspace am I on" or "which keys does this mode bind". Spotspaces fills that gap.

It also adds **app pinning** — a `bundle-id → workspace` registry applied to every newly detected window — so quitting and relaunching an app doesn't leak it onto whatever workspace happened to be focused.

## Installation

The scripts and labels file are managed by this repo via stow:

- `home/.local/bin/aerospace-toggle-pin.sh`
- `home/.local/bin/aerospace-apply-pin.sh`
- `home/.config/aerospace-mode-labels.toml`

After cloning + stowing this repo, install the Spotspaces app itself from `~/Projets/Spotspaces` (private). It registers the `spotspaces://` URL handler used by `~/.aerospace.toml` and `~/.skhdrc`.

`jq` is required by the pin scripts: `brew install jq`.

## Integration points

Four hooks connect AeroSpace + skhd to Spotspaces:

| Where | What it does |
|---|---|
| `[[on-window-detected]]` catch-all (`.aerospace.toml`) → `aerospace-apply-pin.sh` | Re-pins every new window if its bundle-id is in the registry |
| `on-mode-changed` (`.aerospace.toml`) → `spotspaces://hide-mode-help` | Hides the mode overlay on any mode transition |
| `lalt - 0x2B` / `lalt - 0x2E` (`.skhdrc`) → `spotspaces://show-mode-help?mode=...` | Tells Spotspaces which mode was just entered (chained after the `aerospace mode …` call) |
| `p` binding in shortcuts mode (`.aerospace.toml`) → `aerospace-toggle-pin.sh` | Toggles the focused app's pin |

The labels file at `~/.config/aerospace-mode-labels.toml` is read live by Spotspaces — edit it whenever new mode bindings are added to AeroSpace.

The pin registry lives at `~/.config/aerospace-locks/registry.json`. It's created by the toggle script the first time a pin is set; Spotspaces never writes to it.

## Reference

Full specs and original installation guide live in the Spotspaces repo:

- `~/Projets/Spotspaces/specs/Spec V3 - App Pinning.md`
- `~/Projets/Spotspaces/specs/Installation App Pinning.md`

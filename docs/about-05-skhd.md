# skhd

Simple hotkey daemon for macOS, written in C. [GitHub](https://github.com/koekeishiya/skhd)

## Why

AeroSpace cannot distinguish left alt from right alt ([issue #28](https://github.com/nikitabobko/AeroSpace/issues/28)). On an AZERTY keyboard, right alt is essential for typing special characters (`@`, `[`, `{`, `}`, `|`, etc.), so using `alt` as the AeroSpace modifier blocks normal typing.

skhd solves this by natively supporting `lalt` and `ralt` as distinct modifiers. All window management bindings use `lalt` (left alt) as the sole modifier, while right alt passes through untouched for AZERTY characters.

This also reduces key combos from 3 keys (`cmd+alt+h`) to 2 keys (`lalt+h`).

## Install

```bash
brew install koekeishiya/formulae/skhd
skhd --start-service
```

Grant Accessibility access: System Settings > Privacy & Security > Accessibility > toggle skhd on.

## Config

Lives in `~/.skhdrc`. Uses hex key codes for keys that differ between AZERTY and QWERTY (numbers, punctuation) — see comments in the config for the mapping table.

### Relationship with AeroSpace

- **skhd** handles all keybindings (focus, move, resize, workspace switch, mode entry, join-with)
- **AeroSpace** handles window management, modes (service/shortcuts), settings, gaps, and startup commands
- skhd calls `aerospace` CLI commands — AeroSpace's `[mode.main.binding]` is intentionally empty
- Modal bindings (plain keys inside service/shortcuts mode) remain in AeroSpace since they don't use alt

### Key bindings summary

| Modifier | Action |
|---|---|
| `lalt + hjkl` | Focus direction |
| `lalt + shift + hjkl` | Move window |
| `lalt + 1-9` | Switch workspace |
| `lalt + shift + 1-9` | Move window to workspace |
| `lalt + tab` | Workspace back-and-forth |
| `lalt + shift + tab` | Move workspace to other monitor |
| `lalt + -/+` | Resize |
| `lalt + /` | Toggle tiles H/V |
| `lalt + ;` | Enter service mode |
| `lalt + ,` | Enter shortcuts mode |
| `lalt + shift + cmd + hjkl` | Join with direction |

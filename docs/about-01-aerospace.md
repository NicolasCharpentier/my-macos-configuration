# AeroSpace

Tiling window manager for macOS. [GitHub](https://github.com/nikitabobko/AeroSpace)

## Why

macOS Spaces and window management just suck. There's a lot of things missing — no instant workspace switching, no way to quickly switch to another window of the same app, and the overall experience feels clunky and slow.

AeroSpace fixes all of that with keyboard-driven, instant workspace and window control.

It could also be a foundation for later building myself a per-ticket workspace spawner.

## Config

Lives in `~/.aerospace.toml`. A cheatsheet is at the top of the config file.

### AZERTY compatibility

The default AeroSpace config uses `alt` as the sole modifier, which breaks AZERTY keyboards: `alt` is required to type essential coding characters (`|`, `~`, `{`, `}`, `[`, `]`, `\`). AeroSpace has no AZERTY preset (only qwerty/dvorak/colemak), and the open issue for left/right alt distinction ([#28](https://github.com/nikitabobko/AeroSpace/issues/28)) is unresolved.

**Modifier: `cmd-alt` instead of `alt`.** This frees `alt` alone for typing special characters. The `cmd-alt` combo naturally overrides conflicting macOS shortcuts (`cmd-alt-h` hide others, `cmd-alt-d` toggle dock, `cmd-alt-m` minimize all) since AeroSpace binds them to AeroSpace commands.

**Key remapping for AZERTY.** Since AeroSpace uses `preset = 'qwerty'`, it maps physical key positions to QWERTY names. Several keys are at different positions on AZERTY vs QWERTY. The config swaps the bindings so that pressing the AZERTY-labeled key does what you'd expect:

- Resize `-` and `+` are remapped to their AZERTY physical positions (QWERTY `equal` and `slash`)
- Layout toggle `/` is remapped to AZERTY position (QWERTY `period`)
- Service mode `;` is remapped to AZERTY position (QWERTY `comma`)

**Arrow key duplicates.** Focus (`cmd-alt-arrows`) and move (`cmd-alt-shift-arrows`) bindings are duplicated on arrow keys in addition to HJKL.

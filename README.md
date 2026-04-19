# my-macos-configuration

> **Note:** sketchybar is temporarily disabled — I'm testing a custom in-house replacement (beta). To re-enable: `brew services start sketchybar` and uncomment the `sketchybar` line in `home/.aerospace.toml` (`after-startup-command`).

This repo centralizes my macOS configuration in one place. Having everything in a single repo means I can track changes over time, set up a new machine quickly, and never lose a config I spent hours tweaking.

## How it works

### `home/`

Contains configuration files that mirror the home directory structure. These files are symlinked into `~` using [GNU Stow](docs/about-02-stow.md), so applications read them as if they were in their normal locations.

### `docs/`

Each tool gets its own `about-XX-toolname.md` file explaining what it is, why I use it, and how it's configured.

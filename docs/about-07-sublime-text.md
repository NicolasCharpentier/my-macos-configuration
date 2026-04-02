# Sublime Text

Text editor with tiling window manager integration.

## Installation

Install [Sublime Text](https://www.sublimetext.com/) from the website or `brew install --cask sublime-text`.

## Configuration

Settings are managed via stow in `home/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings`:

- `hot_exit: false` + `remember_open_files: false` — prevents restoring previous windows/files on launch
- `update_check: false` — disables update/purchase popups

## Shortcut

A new Sublime Text window can be opened in the current workspace via the `new-sublime-window` script (`~/.local/bin/new-sublime-window`), bound to `S` in aerospace shortcuts mode. The script uses the bundled `subl` CLI with `--new-window`.

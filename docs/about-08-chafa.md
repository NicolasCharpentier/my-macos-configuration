# Chafa

Terminal image viewer using the Kitty graphics protocol (supported by Ghostty).

## Installation

```bash
brew install chafa
```

## Usage

```bash
chafa image.png
```

## Useful flags

- `-f, --format=FORMAT` — output format: `kitty`, `sixels`, `iterm`, `symbols`. Use `kitty` for Ghostty.
- `--scale=NUM` — scale image to fit view. Use `max` to fill the terminal.
- `--clear` — clear screen before displaying each file.
- `--watch` — watch the file and redisplay on changes (useful for live-updating images).
- `-d, --duration=SECONDS` — how long to show each file before moving to the next.
- `--animate=BOOL` — enable/disable animation for GIFs and animated formats.
- `--speed=SPEED` — animation speed multiplier or explicit framerate (e.g. `2fps`).

## Example

Display an image fullscreen with live reload:

```bash
chafa --watch -f kitty --scale max --clear image.png
```

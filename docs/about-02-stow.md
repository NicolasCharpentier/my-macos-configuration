# GNU Stow

Symlink farm manager. [Website](https://www.gnu.org/software/stow/)

## Why

Dotfiles need to live in specific locations (home directory, `~/.config/`, etc.) for applications to find them. But I want them versioned in a git repo somewhere else.

Stow bridges the gap — it creates symlinks from the repo into the home directory, so apps see the files where they expect them, but the real files live in the repo.

## Usage

Install with Homebrew:

```bash
brew install stow
```

Apply all configs from this repo:

```bash
REPO_DIR="/path/to/my-macos-configuration"
stow -d "$REPO_DIR/home" -t ~ .
```

This symlinks everything in `home/` into `~`, mirroring the directory structure.

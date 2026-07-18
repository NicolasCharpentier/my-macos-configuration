# Codex instructions

Read `README.md` for context on this repo's structure and purpose.

## Adding a new tool

Every new tool must have a documentation entry in `docs/` named `about-XX-toolname.md` where XX is the next available number. Look at the most recent entries in `docs/` for formatting reference.

## Updating configs

After adding or modifying config files in `home/`, run stow to apply the symlinks:

```bash
stow -d <repo-root>/home -t ~ .
```

Where `<repo-root>` is the absolute path to this cloned repo.

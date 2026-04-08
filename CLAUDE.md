# Claude instructions

Read `README.md` for context on this repo's structure and purpose.

## Adding a new tool

Every new tool must have a documentation entry in `docs/` named `about-XX-toolname.md` where XX is the next available number. Look at the most recent entries in `docs/` for formatting reference.

## Sketchybar popup performance

For sketchybar popups/dropdowns with more than a few items, ALWAYS pre-create a fixed pool of item slots at startup in `sketchybarrc` (with `drawing=off`), then on hover only `--set` their properties and toggle `drawing=on/off` for used/unused slots. NEVER use `--add`/`--remove` dynamically on hover — destroying and recreating CGS windows is extremely slow (~50ms per item via the macOS window server). See `cpu.stats`/`ram.stats` slots in `sketchybarrc` and the `stats.sh` plugin for the reference pattern.

## Updating configs

After adding or modifying config files in `home/`, run stow to apply the symlinks:

```bash
stow -d <repo-root>/home -t ~ .
```

Where `<repo-root>` is the absolute path to this cloned repo.

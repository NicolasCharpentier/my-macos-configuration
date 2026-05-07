# Bash

GNU Bourne-Again SHell. Used as the script interpreter (via `#!/usr/bin/env bash` shebangs) for shell scripts in this repo. Not used as the interactive login shell — that's zsh.

## Why install it

macOS ships **bash 3.2.57 from 2007** at `/bin/bash`. Apple is frozen on that version because everything newer is GPLv3, which Apple refuses to ship. As a result, `/bin/bash` is missing roughly 18 years of language features.

Useful features only available in bash 4+/5+:

- **Associative arrays** (`declare -A`)
- **Globstar** (`**/*.sh`) — recursive globbing
- **`mapfile` / `readarray`** — read file lines into an array
- **`${var^^}` / `${var,,}`** — case conversion
- **`&>>`** — append both stdout and stderr
- **`wait -n`**, **`$EPOCHSECONDS`**, **`$EPOCHREALTIME`** — bash 5+

Running scripts that use these features under the system bash 3.2 causes silent breakage.

## Installation

```bash
brew install bash
```

This installs bash 5.3+ at `/opt/homebrew/bin/bash`. Because `/opt/homebrew/bin` comes before `/bin` in `$PATH`, `#!/usr/bin/env bash` shebangs automatically pick up the Homebrew bash — no shebang changes required.

No need to change the login shell, add to `/etc/shells`, or `chsh`. The system bash at `/bin/bash` stays in place for anything that hardcodes that path.

## Verifying

```bash
which bash              # /opt/homebrew/bin/bash
bash --version          # GNU bash, version 5.3.x
/bin/bash --version     # GNU bash, version 3.2.57 (still there, untouched)
```

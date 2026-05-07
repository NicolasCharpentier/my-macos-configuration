# SketchyBar (retiré)

Barre de statut macOS entièrement personnalisable, écrite en C. [GitHub](https://github.com/FelixKratz/SketchyBar)

## Ce que c'était

Remplacement complet de la barre de menu native macOS. Utilisé comme compagnon d'AeroSpace (tiling WM) pour afficher les indicateurs de workspace, l'app active, l'horloge, la batterie, le volume, le micro, etc. Tout est piloté par des scripts shell (plugins) et un système d'événements.

Un module "Workspace Summarizer" ajoutait du nommage automatique des workspaces via Claude CLI (Haiku), avec un panneau de contrôle intégré dans la barre.

## Pourquoi c'est retiré

Trop bas niveau. SketchyBar part d'une page blanche : il faut ré-implémenter soi-même tout ce que macOS fournit déjà dans sa barre native (horloge, batterie, wifi, volume, bluetooth, notifications...). Chaque élément demande un plugin shell, du debug, du profiling de performance.

L'objectif principal était d'afficher les workspaces AeroSpace — une app privée dédiée (Spotspaces) remplit ce rôle de manière plus simple et fiable.

## Ce qui a été supprimé

- `brew uninstall sketchybar sketchybar-system-stats font-sketchybar-app-font`
- `~/.config/sketchybar/` (sketchybarrc + ~20 plugins + assets)
- `~/.config/workspace-summarizer/` + `~/.cache/workspace-summarizer/`
- Scripts : `workspace-summarizer`, `workspace-summarizer-trigger`
- Toutes les références `sketchybar --trigger` dans `.aerospace.toml` et `.skhdrc`

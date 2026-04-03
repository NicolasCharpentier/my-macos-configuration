# Refonte des workspaces SketchyBar en intercalaires de classeur

## Contexte

J'utilise AeroSpace comme tiling window manager avec SketchyBar. Mes workspaces sont affichés dans la barre sous forme d'items côte à côte. Je veux transformer leur apparence pour qu'ils fonctionnent visuellement comme des intercalaires de classeur physique.

## Le concept d'intercalaire

Chaque workspace est un onglet. Celui qui est **affiché sur le moniteur** doit apparaître comme un intercalaire "levé" : il est plus haut que les autres (quelques pixels de plus en hauteur), et son fond est exactement la même couleur que le background du bureau en dessous. Ça crée une continuité visuelle — l'onglet et le contenu en dessous ne font qu'un, comme si on avait soulevé une languette de classeur.

Les onglets inactifs (non affichés) restent plus courts et ont un fond légèrement plus clair/différent, en retrait visuel.

## Couleurs et thème

Thème sombre, tons chauds. Voici la palette exacte :

- **Fond barre (bar background)** : `#3a3630`
- **Onglet affiché (intercalaire levé)** : `#2c2926`
- **Onglet inactif** : `#4a4540`
- **Texte actif** : `#d4cfc7`
- **Texte inactif** : `#7a756d`
- **Doré (focused)** : `#c8a84e`
- **Doré transparent (previous)** : `rgba(200, 168, 78, 0.35)`
- **Fond doré transparent (previous badge)** : `rgba(200, 168, 78, 0.18)`

## Le background du bureau

Le wallpaper/background de macOS doit être défini programmatiquement à la couleur `#2c2926` (couleur unie, identique au fond de l'intercalaire levé). Comme ça la continuité visuelle entre l'onglet affiché et le bureau est parfaite. Installe ce qu'il faut pour que ça marche.

## Deux couches d'information indépendantes

Il y a deux infos distinctes à afficher, et elles ne se mélangent pas :

### Couche 1 — Quel workspace est affiché sur ce moniteur

C'est l'intercalaire levé/baissé. Purement géométrique, pas de couleur. L'onglet du workspace visible sur le moniteur est plus haut et a le fond sombre (`#2c2926`). Les autres sont plus courts avec le fond `#4a4540`. C'est tout.

### Couche 2 — Quel workspace a le focus clavier, et lequel l'avait juste avant

Ça se fait via le **numéro du workspace** affiché dans l'onglet :

- **Workspace focused** (celui qui a le focus clavier en ce moment) : le numéro est affiché dans un petit badge doré plein — fond `#c8a84e`, texte sombre (`#2c2926`), `border-radius` arrondi, `font-weight` medium/bold. Le numéro ressort comme une petite pastille.
- **Previous workspace** (le dernier workspace qui avait le focus avant, celui où `alt+tab` ramènerait) : même badge mais en version transparente — fond `rgba(200, 168, 78, 0.18)`, texte `rgba(200, 168, 78, 0.35)`. C'est un fantôme du badge focused.
- **Tous les autres** : le numéro est affiché normalement, en texte muted, sans badge.

Note : le previous workspace peut être sur un autre moniteur que le focused. Les deux couches sont indépendantes — un onglet peut être "levé" (affiché sur son moniteur) sans être focused, et inversement.

## Format des onglets

Chaque onglet affiche : `[numéro] [nom du workspace]`. Le numéro est ce qui porte le badge doré (ou pas). Le nom est en texte normal. Les coins supérieurs des onglets sont arrondis (style `border-radius` en haut, pas en bas) pour le look intercalaire.

## Multi-moniteur

J'ai deux moniteurs. Chaque moniteur a sa propre barre SketchyBar avec ses propres workspaces assignés. Le système d'intercalaire fonctionne par moniteur (chaque moniteur a son propre onglet levé), mais le badge doré focused/previous est global (un seul focused à la fois, un seul previous à la fois, potentiellement sur des moniteurs différents).

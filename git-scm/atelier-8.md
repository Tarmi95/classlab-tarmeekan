## Atelier 8 : Personnaliser Git

## Objectifs

- Configurer Git à différents niveaux (système, global, local).
- Créer des alias pour les commandes fréquentes.
- Découvrir les outils graphiques.

---

### PARTIE 1 — Les niveaux de configuration

Git utilise trois niveaux de configuration, du moins prioritaire au plus prioritaire :

| Niveau     | Fichier          | Portée                              |
| ---------- | ---------------- | ----------------------------------- |
| `--system` | `/etc/gitconfig` | Tous les utilisateurs de la machine |
| `--global` | `~/.gitconfig`   | Ton compte utilisateur              |
| `--local`  | `.git/config`    | Le dépôt courant uniquement         |

Affiche la configuration active et son origine :

```bash
git config --list --show-origin
```

Affiche la valeur d'une clé :

```bash
git config user.name
git config --global user.name
```

---

### PARTIE 2 — Configurer les outils essentiels

Configure l'éditeur par défaut :

```bash
# VS Code
git config --global core.editor "code --wait"

# Nano
git config --global core.editor nano

# Vim
git config --global core.editor vim
```

Configure les fins de ligne (important en équipe mixte Windows/Linux) :

```bash
# Sur Windows : convertit LF en CRLF au checkout, CRLF en LF au commit
git config --global core.autocrlf true

# Sur Linux/macOS : convertit CRLF en LF au commit, ne modifie pas au checkout
git config --global core.autocrlf input
```

Configure le fichier d'exclusions global (gitignore global) :

```bash
git config --global core.excludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global
echo "Thumbs.db" >> ~/.gitignore_global
echo ".idea/" >> ~/.gitignore_global
```

Active la colorisation de l'interface :

```bash
git config --global color.ui auto
```

Définit la branche par défaut pour les nouveaux dépôts :

```bash
git config --global init.defaultBranch main
```

Affiche la configuration globale complète :

```bash
cat ~/.gitconfig
```

**Questions :**

- Quel niveau de configuration prend la priorité sur les autres ?

---

### PARTIE 3 — Créer des alias

Les alias raccourcissent les commandes longues. Ils s'ajoutent dans `~/.gitconfig` sous la section `[alias]`.

Alias courants à configurer :

```bash
st = status
co = checkout
br = branch
ci = commit
lg = log --oneline --graph --all --decorate
last = log -1 HEAD --stat
unstage = restore --staged
undo = reset --soft HEAD~1
```

Test des alias :

```bash
mkdir ~/atelier-config && cd ~/atelier-config
git init
echo "test" > fichier.txt
git st
git add .
git ci -m "test alias"
git lg
git last
```

Affiche tous les alias définis :

```bash
git config --global --list | grep alias
```

**Questions :**

- Comment modifier un alias existant ?

---

### PARTIE 4 — Outils graphiques

Les interfaces graphiques facilitent la visualisation des branches, diffs et historiques.

**Outils tiers populaires :**

| Outil                       | Plateforme          | Gratuit       |
| --------------------------- | ------------------- | ------------- |
| **GitKraken**               | Windows/macOS/Linux | Partiellement |
| **SmartGit**                | Windows/macOS/Linux | Partiellement |
| **Sourcetree**              | Windows/macOS       | Oui           |
| **VS Code** (intégré)       | Windows/macOS/Linux | Oui           |
| **IntelliJ IDEA** (intégré) | Windows/macOS/Linux | Partiellement |

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-9.md)

Retour à la page [Débuter avec Git](README.md).

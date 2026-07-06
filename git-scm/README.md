# Débuter avec Git

[Git](https://git-scm.com/) est un système de contrôle de version distribué open source crée en 2005 par [Linus Torvalds](https://fr.wikipedia.org/wiki/Linus_Torvalds).

Pour installer Git sur ta machine cliques [ici](https://git-scm.com/).

## Avant de démarrer avec Git

- Vérification de l'installation de Git

```bash
git --version
```

- Configurer son identité utilisateur

```bash
git config --global user.name "Prénom Nom"
git config --global user.email "ton.email@example.com"
```

- Nommer main la branche par défaut lors d'initialisation

```bash
git config --global init.defaultBranch main
```

- Vérifier la configuration actuelle

```bash
git config --list
```

---

## Atelier 1 : Exploiter le dépôt local et son cycle de vie

## 🎯 Objectifs

- Maîtriser les trois zones (répertoire de travail, index, dépôt), le cycle de vie d'un fichier, `.gitignore`, et la suppression/déplacement de fichiers.

➡️ A toi de jouer, cliques [ici](atelier-1.md) !

---

## Atelier 2 : Visualiser l'historique, étiqueter et rechercher

## 🎯 Objectifs

- Lire et filtrer l'historique avec `git log`, visualiser les diffs, créer des tags et rechercher avec `git grep`.

➡️ A toi de jouer, cliques [ici](atelier-2.md) !

---

## Atelier 3 : Annuler des actions

## 🎯 Objectifs

- Corriger le dernier commit, désindexer un fichier, réinitialiser un fichier modifié, comprendre `git reset`.

➡️ A toi de jouer, cliques [ici](atelier-3.md) !

---

## Atelier 4 : Travailler avec les branches

## 🎯 Objectifs

- Maîtriser HEAD, créer et supprimer des branches, fusionner (fast-forward et 3-way), gérer les conflits, connaître les stratégies GitFlow et trunk-based.

➡️ A toi de jouer, cliques [ici](atelier-4.md) !

---

## Atelier 5 : Travailler avec un dépôt distant

## 🎯 Objectifs

- Gérer les dépôts distants, les branches distantes et le suivi de branche. Fetch, pull, push et collaboration en équipe.

➡️ A toi de jouer, cliques [ici](atelier-5.md) !

---

## Atelier 6 : Réécrire l'histoire — rebaser

## 🎯 Objectifs

- Comprendre les risques du rebasage, rebaser une branche, utiliser le rebase interactif, savoir quand rebaser vs fusionner.

➡️ A toi de jouer, cliques [ici](atelier-6.md) !

---

## Atelier 7 : Remiser et nettoyer

## 🎯 Objectifs

- Sauvegarder un travail en cours avec `git stash`, créer une branche depuis une remise, nettoyer le répertoire avec `git clean`.

➡️ A toi de jouer, cliques [ici](atelier-7.md) !

---

## Atelier 8 : Personnaliser Git

## 🎯 Objectifs

- Configurer Git à différents niveaux, créer des alias, découvrir les outils graphiques, mettre en place des hooks côté client et côté serveur.

➡️ A toi de jouer, cliques [ici](atelier-8.md) !

---

## Atelier 9 : Les sous-modules

## 🎯 Objectifs

- Déclarer, cloner et mettre à jour un sous-module. Modifier du code dans un sous-module, gérer les conflits et identifier les limites des sous-modules.

➡️ A toi de jouer, cliques [ici](atelier-9.md) !

---

## 📚 Aide mémoire

➡️ Pour consulter l'aide mémoire, cliques [ici](aide-memoire.md) !

---

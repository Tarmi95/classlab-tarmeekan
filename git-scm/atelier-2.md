## Atelier 2 : Visualiser l'historique, étiqueter et rechercher

## Objectifs

- Lire et filtrer l'historique des commits avec `git log`.
- Visualiser et exporter les différences entre commits.
- Étiqueter des versions importantes avec les tags.
- Rechercher dans le contenu des fichiers avec `git grep`.

---

### PARTIE 1 — Préparer un historique de travail

Crée un dépôt avec plusieurs commits pour pouvoir explorer l'historique :

```bash
mkdir atelier-log && cd atelier-log
git init
git config user.name "Alice"
git config user.email "alice@example.com"

echo "# Projet" > README.md
git add . && git commit -m "feat: initialisation du projet"

echo "def hello(): pass" > app.py
git add . && git commit -m "feat: ajout de la fonction hello"

echo "def goodbye(): pass" >> app.py
git add . && git commit -m "feat: ajout de la fonction goodbye"

echo "*.pyc" > .gitignore
git add . && git commit -m "chore: ajout gitignore Python"

git config user.name "Bob"
git config user.email "bob@example.com"

echo "Corrections orthographiques" >> README.md
git add . && git commit -m "docs: mise à jour du README"
```

---

### PARTIE 2 — Visualiser les modifications avec git log

Affiche l'historique complet :

```bash
git log
```

Historique condensé sur une ligne par commit :

```bash
git log --oneline
```

Affiche le graphe des branches :

```bash
git log --oneline --graph --all
```

Affiche les statistiques des fichiers modifiés :

```bash
git log --stat
```

Affiche le diff complet de chaque commit :

```bash
git log -p
```

**Questions :**

- Que représente le hash affiché devant chaque commit ?
- Quelle option affiche à la fois le graphe et les noms de branches ?

---

### PARTIE 3 — Personnaliser le format d'affichage

Utilise un format prédéfini :

```bash
git log --pretty=short
git log --pretty=fuller
```

Crée un format personnalisé :

```bash
git log --pretty=format:"%h - %an, %ar : %s"
```

| Placeholder | Signification     |
| ----------- | ----------------- |
| `%h`        | Hash court        |
| `%an`       | Nom de l'auteur   |
| `%ar`       | Date relative     |
| `%s`        | Sujet du commit   |
| `%ad`       | Date de l'auteur  |
| `%cn`       | Nom du committeur |

Affiche les N derniers commits uniquement :

```bash
git log -3
```

**Question :**

- Quelle différence entre auteur (`%an`) et committeur (`%cn`) dans Git ?

---

### PARTIE 4 — Filtrer l'historique

Par auteur :

```bash
git log --author="Alice"
```

Par date :

```bash
git log --since="2 weeks ago"
git log --after="2025-01-01" --before="2026-01-01"
```

Par mot-clé dans le message de commit :

```bash
git log --grep="feat"
```

Par contenu modifié (recherche une chaîne dans les diffs) :

```bash
git log -S "hello"
```

Par fichier concerné :

```bash
git log -- app.py
```

Combine plusieurs filtres :

```bash
git log --author="Alice" --grep="feat" --oneline
```

**Questions :**

- Quelle option cherche dans le contenu des diffs plutôt que dans les messages ?
- Comment afficher l'historique d'un seul fichier ?

---

### PARTIE 5 — Visualiser et exporter une différence

Différence entre le répertoire de travail et l'index :

```bash
echo "nouvelle ligne" >> README.md
git diff
```

Différence entre l'index et le dernier commit :

```bash
git add README.md
git diff --cached
```

Différence entre deux commits :

```bash
git diff HEAD~2 HEAD
```

Différence sur un seul fichier entre deux commits :

```bash
git diff HEAD~1 HEAD -- README.md
```

Exporte le diff dans un fichier patch :

```bash
git diff HEAD~1 HEAD > mes-changements.patch
```

**Question :**

- Quelle différence entre `git diff` et `git diff --cached` ?

---

### PARTIE 6 — Étiqueter ses validations

Les tags marquent des versions importantes (releases).

**Tag léger** (simple pointeur vers un commit) :

```bash
git tag v1.0
git tag
```

**Tag annoté** (recommandé : contient auteur, date, message) :

```bash
git tag -a v1.1 -m "Version 1.1 : ajout de goodbye"
git show v1.1
```

Tague un commit passé :

```bash
git log --oneline
git tag -a v0.9 <hash-du-commit> -m "Version initiale"
```

A savoir pour pousser les tags vers le dépôt distant :

```bash
git push origin v1.1
git push origin --tags   # pousse tous les tags
```

Supprime un tag local et distant :

```bash
git tag -d v0.9
git push origin --delete v0.9
```

**Questions :**

- Pourquoi préférer un tag annoté à un tag léger ?
- Comment lister uniquement les tags correspondant à un pattern (ex. `v1.*`) ?

---

### PARTIE 7 — Rechercher avec git grep

`git grep` recherche dans les fichiers du dépôt (plus rapide que `grep` car il respecte `.gitignore`) :

Recherche un mot dans tous les fichiers suivis :

```bash
git grep "hello"
```

Affiche les numéros de ligne :

```bash
git grep -n "hello"
```

Insensible à la casse :

```bash
git grep -i "Hello"
```

Recherche dans un commit précis :

```bash
git grep "hello" HEAD~2
```

Recherche dans toutes les branches :

```bash
git grep "hello" $(git rev-list --all)
```

**Questions :**

- Quelle différence entre `git grep` et `grep -r` dans un projet Git ?
- Quelle différence entre `git grep` et `grep -r` classique dans un projet Git ?
- Comment rechercher une expression régulière avec `git grep` ?

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-3.md)

Retour à la page [Débuter avec Git](README.md).

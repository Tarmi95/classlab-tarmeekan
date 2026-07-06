## Atelier 4 : Travailler avec les branches

## Objectifs

- Comprendre le rôle du pointeur HEAD et des branches.
- Créer, basculer et supprimer des branches.
- Fusionner des branches (avance rapide et trois sources).
- Gérer les conflits de fusion.
- Comprendre les stratégies de gestion de branches.

---

### PARTIE 1 — Préparer l'environnement

```bash
mkdir atelier-branches && cd atelier-branches
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

echo "# Application" > README.md
echo "v1" > version.txt
git add . && git commit -m "feat: initialisation"

echo "page d'accueil" > index.html
git add . && git commit -m "feat: ajout index.html"
```

---

### PARTIE 2 — Principe de branche et pointeur HEAD

Une branche est simplement un **pointeur vers un commit**. HEAD est le pointeur vers la branche (ou le commit) actuelle.

Affiche où pointe HEAD :

```bash
cat .git/HEAD
git log --oneline --decorate
```

Affiche toutes les branches et leurs commits :

```bash
git branch -v
```

**Question :**

- Que contient le fichier `.git/HEAD` quand tu es sur la branche `main` ?

---

### PARTIE 3 — Créer et basculer entre les branches

Crée une branche sans basculer dessus :

```bash
git branch feature-login
git branch
```

Bascule sur cette branche :

```bash
git switch feature-login
```

Crée une branche et bascule directement (raccourci) :

```bash
git switch -c feature-dashboard
```

Ajoute un commit sur cette branche :

```bash
echo "<div>Dashboard</div>" > dashboard.html
git add . && git commit -m "feat: ajout dashboard"
```

Reviens sur `main` et observe que `dashboard.html` a disparu :

```bash
git switch main
ls
```

Affiche le graphe des branches :

```bash
git log --oneline --graph --all
```

**Le mode détaché (detached HEAD)**

Bascule directement sur un commit (sans branche) :

```bash
git checkout HEAD~1
```

Git affiche un avertissement. Tu peux explorer mais tout commit créé ici sera perdu si tu changes de branche sans créer une nouvelle branche.

Pour sauvegarder ton travail depuis un HEAD détaché :

```bash
git switch -c sauvegarde-exploration
```

Reviens sur `main` :

```bash
git switch main
```

**Questions :**

- Que signifie "HEAD détaché" (detached HEAD) ?
- Quelle différence entre `git switch` et `git checkout` pour changer de branche ?

---

### PARTIE 4 — Fusionner les branches : avance rapide

L'**avance rapide** (fast-forward) se produit quand la branche cible n'a pas divergé depuis la création de la branche à fusionner.

```bash
git switch -c feature-footer
echo "<footer>© 2026</footer>" > footer.html
git add . && git commit -m "feat: ajout footer"

git switch main
git merge feature-footer
git log --oneline --graph
```

Observe que Git n'a pas créé de commit de fusion : il a simplement avancé le pointeur de `main`.

Pour forcer un commit de fusion même en avance rapide :

```bash
git switch -c feature-header
echo "<header>Mon Site</header>" > header.html
git add . && git commit -m "feat: ajout header"

git switch main
git merge --no-ff feature-header -m "merge: intégration feature-header"
git log --oneline --graph
```

**Question :**

- Quand préférer `--no-ff` à une fusion en avance rapide ?

---

### PARTIE 5 — Fusionner les branches : trois sources

La fusion **trois sources** (3-way merge) crée un commit de fusion quand les deux branches ont divergé.

```bash
# Commit sur main
echo "v2" > version.txt
git add . && git commit -m "core: version 2"

# Commit sur une branche
git switch -c feature-about
echo "<p>À propos</p>" > about.html
git add . && git commit -m "feat: page à propos"

# Fusion
git switch main
git merge feature-about
git log --oneline --graph --all
```

Git crée automatiquement un commit de fusion car les deux branches ont des commits différents.

---

### PARTIE 6 — Gérer les conflits de fusion

Un conflit survient quand les deux branches modifient **le même endroit du même fichier**.

```bash
# Modification sur main
echo "Contenu version main" > conflit.txt
git add . && git commit -m "core: fichier conflit version main"

# Modification sur une branche
git switch -c feature-conflit
echo "Contenu version feature" > conflit.txt
git add . && git commit -m "core: fichier conflit version feature-conflit"

# Revenir sur main et modifier le même fichier
git switch main
echo "Nouveau contenu version main" > conflit.txt
git add . && git commit -m "core: modification fichier conflit version main"

# Tentative de fusion
git merge feature-conflit
```

Git signale un conflit. Ouvre le fichier `conflit.txt` :

```bash
cat conflit.txt
```

Tu vois les marqueurs de conflit :

```
<<<<<<< HEAD
Nouveau contenu version main
=======
Contenu version feature
>>>>>>> feature-conflit
```

Résouds le conflit manuellement en gardant ce que tu veux :

```bash
echo "Contenu fusionné final" > conflit.txt
```

Marque le conflit comme résolu et valide :

```bash
git add conflit.txt
git commit -m "merge: résolution du conflit sur conflit.txt"
git log --oneline --graph
```

**Questions :**

- Que signifient les trois sections entre marqueurs (`<<<`, `===`, `>>>`) ?
- Comment abandonner une fusion en cours ?

---

### PARTIE 7 — Visualiser et supprimer les branches

Affiche toutes les branches locales :

```bash
git branch
```

Affiche les branches déjà fusionnées dans `main` (sûres à supprimer) :

```bash
git branch --merged
```

Affiche les branches non fusionnées :

```bash
git branch --no-merged
```

Supprime une branche fusionnée :

```bash
git branch -d feature-footer
git branch -d feature-header
git branch -d feature-about
git branch -d feature-conflit
```

Force la suppression d'une branche non fusionnée :

```bash
git branch -D feature-login
```

`-D` supprime la branche et ses commits si non fusionnés.

**Question :**

- Pourquoi `git branch -d` refuse parfois de supprimer une branche ?

---

### PARTIE 8 — Stratégies de gestion de branches

**Branche longue** : des branches qui vivent indéfiniment.

```
main        ──●──────────────────●── (production stable)
develop     ──●──●──●──●──●──●──●── (intégration continue)
```

**Branche thématique** (feature branch) : créée pour une fonctionnalité, supprimée après fusion.

```
main        ──●───────────────────●──
feature-X     └──●──●──●──┘
```

**GitFlow** : `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`.

**Trunk-based development** : tout le monde pousse directement sur `main` (ou une branche de très courte durée), avec des feature flags.

Crée une structure GitFlow simplifiée :

```bash
git switch -c develop
git switch -c feature/nouvelle-fonctionnalite develop
echo "code" > nouvelle-fonctionnalite.py
git add . && git commit -m "feat: nouvelle fonctionnalité"
git switch develop && git merge --no-ff feature/nouvelle-fonctionnalite -m "merge: feature/nouvelle-fonctionnalite"
git branch -d feature/nouvelle-fonctionnalite
```

**Questions :**

- Quel modèle de branches est le plus adapté à une équipe qui déploie plusieurs fois par jour ?
- Quels sont les inconvénients de GitFlow pour les petites équipes ?

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-5.md)

Retour à la page [Débuter avec Git](README.md).

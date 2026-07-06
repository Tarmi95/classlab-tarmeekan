## Atelier 7 : Remiser et nettoyer

## Objectifs

- Sauvegarder temporairement un travail en cours sans faire de commit.
- Créer une branche à partir d'une remise (stash).
- Nettoyer les fichiers non suivis du répertoire de travail.

---

### PARTIE 1 — Préparer l'environnement

```bash
mkdir ~/atelier-stash && cd ~/atelier-stash
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

echo "# Application" > README.md
echo "def main(): pass" > app.py
git add . && git commit -m "feat: initialisation"
```

---

### PARTIE 2 — Remiser son travail en cours

**Scénario** : tu travailles sur une fonctionnalité, et on te demande de corriger un bug urgent sur `main`. Tu n'es pas prêt à committer, mais tu ne veux pas perdre tes modifications.

Simule un travail en cours :

```bash
echo "def nouvelle_fonction(): pass" >> app.py
echo "notes de développement" > notes.txt
git add app.py   # app.py est dans l'index, notes.txt ne l'est pas
```

Remise le travail en cours (index + répertoire de travail) :

```bash
git stash
git status
```

Le répertoire est propre. `notes.txt` n'a pas été remis car il n'est pas suivi.

Pour remiser aussi les fichiers non suivis :

```bash
echo "notes de développement" > notes.txt
git stash -u
git status
ls
```

Affiche la liste des remises :

```bash
git stash list
```

Chaque remise est identifiée par `stash@{N}`.

Affiche le contenu d'une remise sans l'appliquer :

```bash
git stash show stash@{0}
git stash show -p stash@{0}   # diff complet
```

**Questions :**

- Que se passe-t-il avec `notes.txt` si tu fais `git stash` sans `-u` ?
- Comment donner un nom descriptif à une remise ?

---

### PARTIE 3 — Récupérer une remise

Corrige le bug urgent sur `main` :

```bash
git switch -c hotfix-bug
echo "# Bug corrigé" >> README.md
git add . && git commit -m "fix: correction bug urgent"
git switch main
git merge --no-ff hotfix-bug -m "merge: hotfix-bug"
git branch -d hotfix-bug
```

Reviens sur ta fonctionnalité et réapplique la remise :

```bash
git switch -c feature-en-cours
git stash pop
git status
```

`stash pop` applique la dernière stash **et la supprime** de la liste.

Pour appliquer sans supprimer (pour réutiliser la remise sur d'autres branches) :

```bash
git stash apply stash@{0}
```

Pour appliquer une remise spécifique :

```bash
git stash list
git stash pop stash@{1}
```

Supprime une remise sans l'appliquer :

```bash
git stash drop stash@{0}
```

Vide toutes les remises :

```bash
git stash clear
```

**Questions :**

- Quelle différence entre `git stash pop` et `git stash apply` ?
- Peut-on appliquer une stash sur une branche différente de celle où elle a été créée ?

---

### PARTIE 4 — Créer une branche depuis une remise

Utile quand le travail remisé s'avère finalement trop complexe pour la branche courante.

Crée une nouvelle remise :

```bash
echo "def fonctionnalite_complexe(): pass" >> app.py
git stash -u -m "fonctionnalité complexe en cours"
```

Crée une branche directement depuis cette remise :

```bash
git stash branch feature-complexe stash@{0}
```

Git crée la branche à partir du commit où la remise a été effectuée, applique la remise et la supprime de la liste.

Vérifie l'état :

```bash
git status
git log --oneline
```

**Question :**

- Pourquoi `git stash branch` est-il plus fiable que `git stash apply` si le code source a beaucoup évolué depuis la remise ?

---

### PARTIE 5 — Nettoyer le répertoire de travail

`git clean` supprime les fichiers **non suivis** (non trackés) du répertoire de travail.

Crée des fichiers non suivis :

```bash
echo "log" > debug.log
echo "build" > build.tmp
mkdir cache && echo "data" > cache/data.bin
```

Affiche ce qui serait supprimé (mode simulation) :

```bash
git clean -n
```

Supprime les fichiers non suivis :

```bash
git clean -f
```

Supprime aussi les dossiers non suivis :

```bash
git clean -fd
```

Supprime aussi les fichiers ignorés par `.gitignore` :

```bash
echo "*.tmp" > .gitignore
git add .gitignore && git commit -m "chore: gitignore"
echo "residue" > build.tmp
git clean -fx   # supprime aussi les fichiers ignorés
```

Pour supprimer **tout** (non suivis + ignorés + dossiers) :

```bash
git clean -fdx
```

`git clean` est **irréversible** : les fichiers supprimés ne vont pas dans la corbeille.

**Questions :**

- Quelle option de `git clean` est indispensable pour ne pas supprimer accidentellement un fichier important ?
- Comment exclure un fichier spécifique de la suppression lors d'un `git clean` ?

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-8.md)

Retour à la page [Débuter avec Git](README.md).

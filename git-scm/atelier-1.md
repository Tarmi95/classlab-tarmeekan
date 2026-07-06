## Atelier 1 : Exploiter le dépôt local et son cycle de vie

## Objectifs

- Comprendre les trois zones de Git : répertoire de travail, index et dépôt.
- Maîtriser le cycle de vie d'un fichier : status, add, commit.
- Ignorer des fichiers avec `.gitignore`.
- Supprimer et déplacer des fichiers de façon propre.

---

### PARTIE 1 — Les trois zones de Git

Git distingue trois zones :

| Zone                        | Rôle                                                |
| --------------------------- | --------------------------------------------------- |
| **Répertoire de travail**   | Les fichiers que tu vois et édites                  |
| **Index (zone de staging)** | Les modifications préparées pour le prochain commit |
| **Dépôt (HEAD)**            | L'historique des commits validés                    |

```
Répertoire de travail  →  git add  →  Index  →  git commit  →  Dépôt
```

---

### PARTIE 2 — Vérifier l'état de la copie de travail

Crée un dossier de travail et initialise un dépôt :

```bash
mkdir atelier-cycle && cd atelier-cycle
git init
git config user.name "Ton Nom" # Si different du global
git config user.email "ton@email.com" # Si different du global
```

Crée quelques fichiers :

```bash
echo "# Projet" > README.md
echo "# Bonjour" > index.html
echo "secret" > .env
echo ".env" > .gitignore
```

Vérifie l'état :

```bash
git status
```

Observe les catégories affichées : **Untracked files**, **Changes not staged**, **Changes to be committed**.

Pour un affichage court :

```bash
git status -s
```

**Questions :**

- Quelle différence entre `git status` et `git status -s` ?

---

### PARTIE 3 — Indexer ses modifications

Ajoute uniquement `README.md` :

```bash
git add README.md
git status
```

Modifie `README.md` sans le réindexer :

```bash
echo "Première ligne" >> README.md
git status
```

Observe que `README.md` apparaît à la fois dans **Changes to be committed** et **Changes not staged**.

Ajoute toutes les modifications d'un coup :

```bash
git add .
git status
```

---

### PARTIE 4 — Ignorer des fichiers

Le fichier `.gitignore` indique à Git les fichiers à ne jamais suivre.

Vérifie que `.env` est ignoré :

```bash
git check-ignore -v .env
```

Il ne devrait pas apparaître. Ajoute d'autres règles dans `.gitignore` :

```bash
echo "*.log" >> .gitignore
echo "dist/" >> .gitignore
```

Crée un fichier qui correspond à ces règles :

```bash
echo "erreur" > app.log
mkdir dist && echo "build" > dist/bundle.js
git status
```

Vérifie qu'un fichier est ignoré et pourquoi :

```bash
git check-ignore -v app.log
```

Pour ignorer globalement (tous tes projets) :

```bash
git config --global core.excludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global
```

**Questions :**

- Que se passe-t-il si tu ajoutes un fichier déjà suivi à `.gitignore` ?
- Quelle commande force l'ajout d'un fichier ignoré ?

---

### PARTIE 5 — Valider ses modifications

Effectue ton premier commit :

```bash
git add .
git commit -m "Initialisation du projet"
```

Commit en ajoutant automatiquement les fichiers déjà suivis (sans `git add`) :

```bash
echo "Contenu" >> README.md
git commit -am "Mise à jour du README"
```

Affiche le résumé du dernier commit :

```bash
git show --stat HEAD
```

**Question :**

- L'option `-a` de `git commit -am` inclut-elle les nouveaux fichiers non suivis ?

---

### PARTIE 6 — Supprimer et déplacer des fichiers

Crée un fichier à supprimer :

```bash
echo "temporaire" > temp.txt
git add temp.txt && git commit -m "Ajout temp.txt"
```

Supprime-le proprement avec Git (supprime du disque ET de l'index) :

```bash
git rm temp.txt
git status
git commit -m "Suppression de temp.txt"
```

Si tu avais supprimé le fichier manuellement (sans `git rm`), tu aurais dû faire `git add temp.txt` ou `git rm temp.txt` pour enregistrer la suppression dans l'index.

Renomme un fichier :

```bash
git mv README.md LISEZ-MOI.md
git status
git commit -m "Renommage README.md en LISEZ-MOI.md"
```

Compare avec un renommage manuel :

```bash
mv LISEZ-MOI.md README.md
git status
```

Git détecte automatiquement le renommage si le contenu est similaire à plus de 50 %.

**Questions :**

- Quelle différence entre `git rm` et `rm` suivi de `git add` ?
- Comment supprimer un fichier de l'index sans le supprimer du disque ?

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-2.md)

Retour à la page [Débuter avec Git](README.md).

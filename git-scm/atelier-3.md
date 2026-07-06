## Atelier 3 : Annuler des actions

## Objectifs

- Corriger le dernier commit sans en créer un nouveau.
- Désindexer un fichier ajouté par erreur.
- Réinitialiser un fichier modifié à son état précédent.

---

### PARTIE 1 — Préparer l'environnement

```bash
mkdir atelier-annuler && cd atelier-annuler
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

echo "# Projet" > README.md
echo "version: 1.0" > config.yml
git add . && git commit -m "Initialisation"
```

---

### PARTIE 2 — Réécrire la dernière validation

Tu as commité trop vite et oublié un fichier, ou fait une faute dans le message.

Simule l'oubli d'un fichier :

```bash
echo "todo: écrire les tests" > TODO.md
git add README.md
git commit -m "Ajout README et tâches"
# TODO.md n'est pas dans le commit !
```

Ajoute le fichier oublié et amende le commit :

```bash
git add TODO.md
git commit --amend --no-edit
```

Vérifie que le commit contient maintenant les deux fichiers :

```bash
git show --stat HEAD
```

Corrige uniquement le message du dernier commit (sans modifier les fichiers) :

```bash
git commit --amend -m "Ajout README, TODO et config"
```

Vérifie le log :

```bash
git log --oneline
```

**Questions :**

- Le hash du commit a-t-il changé après `--amend` ? Pourquoi ?
- Pourquoi est-il dangereux d'amender un commit déjà poussé sur un dépôt partagé ?

---

### PARTIE 3 — Désindexer un fichier

Tu as ajouté un fichier dans l'index par erreur.

```bash
echo "ma_clé_secrète=abc123" > secrets.txt
git add secrets.txt
git status
```

Le fichier est dans l'index. Retire-le sans modifier le fichier sur le disque :

```bash
git restore --staged secrets.txt
git status
```

Vérifie que le fichier existe toujours sur le disque :

```bash
cat secrets.txt
```

Ajoute-le dans `.gitignore` pour ne plus l'indexer accidentellement :

```bash
echo "secrets.txt" >> .gitignore
git add .gitignore && git commit -m "chore: ignore secrets.txt"
```

💡 **Questions :**

- Que se serait-il passé si tu avais commité `secrets.txt` et poussé sur GitLab ?

---

### PARTIE 4 — Réinitialiser un fichier modifié

Tu as modifié un fichier et veux annuler tes changements pour revenir à la version du dernier commit.

```bash
echo "Mauvaise modification" >> README.md
cat README.md
git status
```

Restaure `README.md` dans l'état du dernier commit :

```bash
git restore README.md
cat README.md
```

Cette opération **écrase irrémédiablement** tes modifications non commitées.

Restaure un fichier dans l'état d'un commit précis :

```bash
echo "autre modification" >> config.yml
git add config.yml && git commit -m "Modification config"

git restore --source HEAD~1 config.yml
cat config.yml
git status
```

Le fichier est revenu à l'état du commit précédent mais apparaît comme modifié dans l'index (tu peux le commiter ou l'annuler).

**Questions :**

- Peut-on récupérer un fichier après `git restore` si la modification n'était pas commitée ?

---

### PARTIE 5 — Comprendre git reset (aperçu)

`git reset` agit sur le pointeur HEAD et éventuellement sur l'index et le répertoire de travail.

| Commande                   | HEAD | Index        | Répertoire de travail |
| -------------------------- | ---- | ------------ | --------------------- |
| `git reset --soft HEAD~1`  | ←    | inchangé     | inchangé              |
| `git reset --mixed HEAD~1` | ←    | réinitialisé | inchangé              |
| `git reset --hard HEAD~1`  | ←    | réinitialisé | réinitialisé          |

Annule le dernier commit en conservant les fichiers modifiés dans l'index :

```bash
git reset --soft HEAD~1
git status
```

Les fichiers sont prêts à être recommités. Recrée le commit :

```bash
git commit -m "Modification config (corrigée)"
```

**Questions :**

- Quelle option de `git reset` est la plus dangereuse ? Pourquoi ?
- Comment récupérer un commit supprimé par `git reset --hard` ?

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-4.md)

Retour à la page [Débuter avec Git](README.md).

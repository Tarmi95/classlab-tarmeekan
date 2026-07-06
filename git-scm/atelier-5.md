## Atelier 5 : Travailler avec un dépôt distant

## Objectifs

- Comprendre les notions de dépôt distant, branches distantes et suivi de branche.
- Afficher, ajouter, renommer et supprimer des dépôts distants.
- Tirer, pousser et supprimer des branches distantes.

---

### PARTIE 1 — Comprendre les dépôts distants

Un **dépôt distant** est une copie du dépôt hébergée ailleurs (GitLab, GitHub, serveur interne…).

Les **branches distantes** (ex. `origin/main`) sont des références locales qui reflètent l'état du dépôt distant lors du dernier contact réseau.

```
Dépôt local          Dépôt distant (origin)
────────────         ─────────────────────
main                 main
origin/main    ←──── (copie locale de l'état distant)
```

---

### PARTIE 2 — Préparer l'environnement

Pour simuler un dépôt distant sans compte GitLab, crée un dépôt nu (bare) local :

```bash
mkdir ~/depot-distant && cd ~/depot-distant
git init --bare
```

Crée ensuite ton dépôt de travail :

```bash
mkdir ~/atelier-distant && cd ~/atelier-distant
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

echo "# Projet distant" > README.md
git add . && git commit -m "feat: initialisation"
```

---

### PARTIE 3 — Afficher et inspecter les dépôts distants

Afficher les dépôts distants avec leurs URLs :

```bash
git remote -v
```

Inspecter un dépôt distant (branches, HEAD, configuration de suivi) :

```bash
git remote show origin
```

---

### PARTIE 4 — Ajouter, renommer et retirer un dépôt distant

Ajoute le dépôt nu créé précédemment comme dépôt distant :

```bash
git remote add origin ~/depot-distant
git remote -v
```

Pousse `main` vers `origin` en définissant le suivi automatique :

```bash
git push -u origin main
```

Renomme le dépôt distant :

```bash
git remote rename origin mon-origin
git remote -v
```

Remets le nom original :

```bash
git remote rename mon-origin origin
```

Retire un dépôt distant (ne supprime pas le dépôt lui-même) :

```bash
git remote remove origin
git remote add origin ~/depot-distant
```

Modifie l'URL d'un dépôt distant existant (utile lors d'une migration de HTTP vers SSH) :

```bash
git remote set-url origin git@gitlab.com:ton-compte/mon-projet.git
```

**Questions :**

- Quelle différence entre `git remote remove` et supprimer physiquement le dépôt distant ?
- Pourquoi passer de HTTPS à SSH pour l'URL d'un dépôt ?

---

### PARTIE 5 — Tirer et pousser

**Récupère** les données distantes sans fusionner :

```bash
git fetch origin
```

Affiche les différences entre ta branche locale et la branche distante après `fetch` :

```bash
git diff main origin/main
```

**Tire** (fetch + merge) pour récupérer et intégrer les changements distants :

```bash
git pull origin main
```

Pour rebaser au lieu de fusionner lors du pull (historique plus propre) :

```bash
git pull --rebase origin main
```

**Pousse** tes commits vers le dépôt distant :

```bash
echo "nouvelle ligne" >> README.md
git add . && git commit -m "docs: mise à jour README"
git push origin main
```

Si ta branche locale a du retard sur l'origine (quelqu'un a poussé entre-temps), Git refusera le push. Il faut d'abord `git pull` :

```bash
git pull --rebase origin main
git push origin main
```

**Questions :**

- Quelle différence entre `git fetch` et `git pull` ?
- Pourquoi préférer `git pull --rebase` à `git pull` dans une équipe ?

---

### PARTIE 6 — Travailler avec des branches distantes

Crée une branche locale et pousse-la :

```bash
git switch -c feature-contact
echo "<p>Nous contacter</p>" > contact.html
git add . && git commit -m "feat: page contact"
git push -u origin feature-contact
```

L'option `-u` (ou `--set-upstream`) lie la branche locale à la branche distante pour les futurs `git push` et `git pull` sans argument.

Liste les branches distantes :

```bash
git branch -r
```

Liste les branches locales et distantes avec leur lien de suivi :

```bash
git branch -vv
```

Récupère une branche distante créée par un collègue :

```bash
git fetch origin
git switch -c feature-contact origin/feature-contact
# ou plus court :
git switch feature-contact
```

Supprime une branche sur le dépôt distant :

```bash
git push origin --delete feature-contact
```

Nettoie les références locales aux branches distantes supprimées :

```bash
git fetch --prune
git branch -r
```

**Questions :**

- Que se passe-t-il si tu fais `git push` sans `-u` sur une nouvelle branche ?
- Comment lister uniquement les branches distantes déjà fusionnées dans `main` ?

---

### PARTIE 7 — Scénario complet en équipe (simulation)

Simule le travail de deux développeurs avec deux clones du même dépôt :

```bash
# Développeur A
cd /tmp
git clone ~/depot-distant devA
cd devA
git config user.name "Alice"
echo "Travail Alice" >> README.md
git add . && git commit -m "docs: ajout Alice"
git push origin main

# Développeur B (dans un autre terminal)
cd /tmp
git clone ~/depot-distant devB
cd devB
git config user.name "Bob"
echo "Travail Bob" >> README.md
git add . && git commit -m "docs: ajout Bob"
git push origin main   # ← refusé car Alice a poussé avant

# Bob doit récupérer les changements d'Alice avant de pousser
git pull --rebase origin main
git push origin main
```

**Questions :**

- Pourquoi Git refuse-t-il le push de Bob ?
- Quelle commande Bob doit-il utiliser pour voir les commits d'Alice avant de rebaser ?

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-6.md)

Retour à la page [Débuter avec Git](README.md).

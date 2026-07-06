## Atelier 6 : Réécrire l'histoire — rebaser

## Objectifs

- Comprendre les risques de la réécriture d'historique.
- Rebaser une branche sur une autre.
- Savoir quand rebaser et quand fusionner.

---

### Mise en garde importante

Le rebase **réécrit les commits** : chaque commit rebasé obtient un nouveau hash. Si ces commits ont déjà été poussés sur un dépôt partagé, les autres contributeurs se retrouveront avec un historique incohérent.

**Ne jamais rebaser une branche publique (partagée).**

---

### PARTIE 1 — Préparer l'environnement

```bash
mkdir atelier-rebase && cd atelier-rebase
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

echo "# App" > README.md
git add . && git commit -m "feat: initialisation"

echo "v1" > version.txt
git add . && git commit -m "core: version 1"

echo "page d'accueil" > index.html
git add . && git commit -m "feat: index"
```

Crée une branche de fonctionnalité à partir d'un commit passé :

```bash
git switch -c feature-api HEAD~2
echo "endpoint /api" > api.py
git add . && git commit -m "feat: endpoint API"
echo "endpoint /api/users" >> api.py
git add . && git commit -m "feat: endpoint users"
```

Affiche le graphe :

```bash
git log --oneline --graph --all
```

Tu vois que `feature-api` est basée sur un commit ancien de `main`.

---

### PARTIE 2 — Rebaser une branche

Le rebase déplace la base de `feature-api` vers la pointe de `main`.

```bash
git rebase main
git log --oneline --graph --all
```

L'historique est maintenant **linéaire** : les commits de `feature-api` ont été rejoués après le dernier commit de `main`.

Observe que les hashes des commits de `feature-api` ont changé :

```bash
git log --oneline feature-api
```

---

### PARTIE 3 — Gérer les conflits lors d'un rebase

Simule un conflit :

````bash
git switch main
echo "v2" > version.txt
git add . && git commit -m "core: version 2 sur main"

git switch -c feature-version
echo "v3" > version.txt
git add . && git commit -m "core: version 3 sur feature"

```bash
git switch main
echo "v4" > version.txt
git add . && git commit -m "core: version 4 sur main"

git switch feature-version
git rebase main
````

Git s'arrête sur le commit en conflit. Résouds le conflit :

```bash
cat version.txt
echo "v3" > version.txt
git add version.txt
```

Continue le rebase (ne pas faire `git commit`) :

```bash
git rebase --continue
```

Pour abandonner le rebase et revenir à l'état d'avant :

```bash
git rebase --abort
```

**Questions :**

- Quelle différence entre `git rebase --continue` et `git commit` lors d'un conflit de rebase ?
- Comment vérifier qu'il n'y a plus de conflit avant de continuer le rebase?

---

### PARTIE 4 — Rebase interactif

Le rebase interactif permet de **réécrire, réorganiser, fusionner ou supprimer** des commits avant de les intégrer.

Affiche les 3 derniers commits :

```bash
git log --oneline -3
```

Lance un rebase interactif sur les 3 derniers commits :

```bash
git rebase -i HEAD~3
```

Git ouvre l'éditeur avec les commits listés :

```
pick abc1234 feat: endpoint API
pick def5678 feat: endpoint users
pick ghi9012 chore: version 3 sur feature
```

Les actions disponibles :

| Action   | Effet                              |
| -------- | ---------------------------------- |
| `pick`   | Conserver le commit tel quel       |
| `reword` | Modifier uniquement le message     |
| `edit`   | S'arrêter pour modifier le commit  |
| `squash` | Fusionner avec le commit précédent |
| `fixup`  | Fusionner sans garder le message   |
| `drop`   | Supprimer le commit                |

Fusionne les deux commits API en un seul : remplace `pick` par `squash` sur la deuxième ligne, sauvegarde et ferme l'éditeur.

💡 **Questions :**

- Pourquoi `squash` est-il utile avant de fusionner une feature branch dans `main` ?
- Quelle action du rebase interactif permet de changer l'ordre des commits ?

---

### PARTIE 5 — Quand rebase, quand fusionner

| Situation                             | Recommandation                                         |
| ------------------------------------- | ------------------------------------------------------ |
| Branche locale privée, jamais poussée | **Rebase** pour un historique propre                   |
| Mise à jour quotidienne depuis `main` | **Rebase** pour éviter les commits de fusion parasites |
| Intégration d'une feature dans `main` | **Merge --no-ff** pour garder la trace de la branche   |
| Branche déjà poussée et partagée      | **Merge** uniquement — jamais de rebase                |
| Hotfix urgent à intégrer rapidement   | **Merge** (rapide et sûr)                              |

**A savoir:**

- `merge` préserve l'historique exact de ce qui s'est passé.
- `rebase` produit un historique propre et linéaire, plus facile à lire.

---

**Atelier terminé ! Félicitations pour ton travail !**

[Passer à l'atelier suivant](atelier-7.md)

Retour à la page [Débuter avec Git](README.md).

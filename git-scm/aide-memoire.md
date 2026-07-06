# Aide-mémoire Git

## Configuration initiale

```bash
git config --global user.name "Prénom Nom"
git config --global user.email "ton.email@example.com"
git config --global core.editor "code --wait"          # éditeur par défaut
git config --global init.defaultBranch main
git config --list --show-origin                        # voir toute la config et son origine
git config --global alias.lg "log --oneline --graph --all --decorate"  # exemple d'alias
```

---

## Créer et initialiser un dépôt

```bash
git init                              # initialiser un dépôt local
git init --bare                       # dépôt nu (serveur)
git clone <url>                       # cloner un dépôt
git clone --recurse-submodules <url>  # cloner avec les sous-modules
```

---

## Cycle de vie des fichiers

```bash
git status                            # état du répertoire de travail
git status -s                         # affichage court

git add <fichier>                     # indexer un fichier
git add .                             # indexer tous les fichiers modifiés
git add -p <fichier>                  # indexer interactivement (hunk par hunk)

git commit -m "message"               # valider les modifications indexées
git commit -am "message"              # indexer les fichiers suivis + valider
git commit --amend                    # modifier le dernier commit (message ou contenu)
git commit --amend --no-edit          # amender sans changer le message

git rm <fichier>                      # supprimer du disque et de l'index
git rm --cached <fichier>             # retirer de l'index sans supprimer du disque
git mv <ancien> <nouveau>             # déplacer ou renommer un fichier
```

---

## Ignorer des fichiers

```bash
echo "*.log" >> .gitignore            # ajouter une règle au .gitignore
git check-ignore -v <fichier>         # vérifier pourquoi un fichier est ignoré
git config --global core.excludesfile ~/.gitignore_global  # gitignore global
```

---

## Visualiser l'historique

```bash
git log                                       # historique complet
git log --oneline                             # une ligne par commit
git log --oneline --graph --all               # graphe des branches
git log --stat                                # fichiers modifiés par commit
git log -p                                    # diff complet par commit
git log --pretty=format:"%h - %an, %ar : %s" # format personnalisé

# Filtrer
git log -5                                    # 5 derniers commits
git log --author="Alice"
git log --since="2 weeks ago"
git log --grep="feat"                         # par mot-clé dans le message
git log -S "chaine"                           # par contenu modifié dans les diffs
git log -- <fichier>                          # historique d'un fichier

git show <hash>                               # détails d'un commit
git show --stat HEAD                          # résumé du dernier commit
```

---

## Comparer les différences

```bash
git diff                          # répertoire de travail vs index
git diff --cached                 # index vs dernier commit
git diff HEAD~1 HEAD              # entre deux commits
git diff <branche1> <branche2>   # entre deux branches
git diff -- <fichier>             # sur un fichier spécifique
git difftool                      # ouvrir l'outil graphique configuré
```

---

## Étiqueter des versions

```bash
git tag                               # lister les tags
git tag v1.0                          # tag léger
git tag -a v1.0 -m "Version 1.0"     # tag annoté (recommandé)
git tag -a v1.0 <hash>               # tagger un commit passé
git show v1.0                         # détails d'un tag annoté
git push origin v1.0                  # pousser un tag
git push origin --tags                # pousser tous les tags
git tag -d v1.0                       # supprimer un tag local
git push origin --delete v1.0         # supprimer un tag distant
```

---

## Rechercher dans le dépôt

```bash
git grep "chaine"           # rechercher dans les fichiers suivis
git grep -n "chaine"        # avec numéros de ligne
git grep -i "chaine"        # insensible à la casse
git grep "chaine" HEAD~2    # dans un commit précis
```

---

## Annuler des actions

```bash
git restore <fichier>                    # annuler les modifs non indexées ( irréversible)
git restore --staged <fichier>           # désindexer un fichier (garde les modifs)
git restore --source HEAD~1 <fichier>    # restaurer depuis un commit précis

git commit --amend                       # réécrire le dernier commit

git reset --soft HEAD~1                  # annuler le commit, garder l'index
git reset --mixed HEAD~1                 # annuler le commit et l'index, garder les fichiers
git reset --hard HEAD~1                  # annuler tout ( irréversible)

git revert <hash>                        # créer un commit d'annulation (sûr en équipe)
```

---

## Branches

```bash
git branch                         # lister les branches locales
git branch -v                      # avec le dernier commit
git branch --merged                # branches déjà fusionnées
git branch --no-merged             # branches non fusionnées

git branch <nom>                   # créer une branche
git switch <nom>                   # basculer sur une branche
git switch -c <nom>                # créer et basculer
git checkout HEAD~1                # HEAD détaché (mode exploration)

git merge <branche>                # fusionner (fast-forward si possible)
git merge --no-ff <branche>        # forcer un commit de fusion
git mergetool                      # résoudre les conflits avec un outil graphique

git branch -d <nom>                # supprimer une branche fusionnée
git branch -D <nom>                # forcer la suppression
```

---

## Dépôt distant

```bash
git remote -v                              # lister les dépôts distants
git remote show origin                     # inspecter un dépôt distant
git remote add <nom> <url>                 # ajouter un dépôt distant
git remote rename <ancien> <nouveau>       # renommer
git remote remove <nom>                    # supprimer
git remote set-url origin <url>            # modifier l'URL

git fetch origin                           # récupérer sans fusionner
git fetch --prune                          # nettoyer les branches distantes supprimées
git pull origin <branche>                  # fetch + merge
git pull --rebase origin <branche>         # fetch + rebase (historique propre)

git push origin <branche>                  # pousser une branche
git push -u origin <branche>              # pousser et définir le suivi
git push origin --delete <branche>         # supprimer une branche distante

git branch -r                              # lister les branches distantes
git branch -vv                             # branches locales avec leur suivi
```

---

## Rebaser

```bash
git rebase <branche>        # rebaser la branche courante sur <branche>
git rebase -i HEAD~3        # rebase interactif sur les 3 derniers commits
git rebase --continue       # continuer après résolution d'un conflit
git rebase --abort          # abandonner le rebasage
```

Actions disponibles dans le rebase interactif :

| Action   | Effet                              |
| -------- | ---------------------------------- |
| `pick`   | Conserver le commit                |
| `reword` | Modifier le message                |
| `squash` | Fusionner avec le commit précédent |
| `fixup`  | Fusionner sans garder le message   |
| `drop`   | Supprimer le commit                |

> Ne jamais rebaser une branche déjà poussée et partagée.

---

## Remiser et nettoyer

```bash
git stash                           # remiser le travail en cours
git stash -u                        # remiser + fichiers non suivis
git stash -m "description"          # remise nommée
git stash list                      # lister les remises
git stash show -p stash@{0}         # voir le contenu d'une remise
git stash pop                       # appliquer et supprimer la dernière remise
git stash apply stash@{0}           # appliquer sans supprimer
git stash drop stash@{0}            # supprimer une remise
git stash clear                     # vider toutes les remises
git stash branch <nom> stash@{0}    # créer une branche depuis une remise

git clean -n                        # simuler la suppression des fichiers non suivis
git clean -f                        # supprimer les fichiers non suivis
git clean -fd                       # supprimer fichiers + dossiers non suivis
git clean -fdx                      # supprimer tout (non suivis + ignorés)
```

---

## Sous-modules

```bash
git submodule add <url> <chemin>           # ajouter un sous-module
git submodule status                        # état des sous-modules
git submodule init                          # initialiser les sous-modules
git submodule update                        # mettre à jour depuis la référence commitée
git submodule update --init --recursive     # initialiser + mettre à jour (récursif)
git submodule update --remote               # mettre à jour vers la dernière version distante
```

---

## Références utiles

| Notation      | Signification                                |
| ------------- | -------------------------------------------- |
| `HEAD`        | Commit courant                               |
| `HEAD~1`      | Commit précédent                             |
| `HEAD~N`      | N commits en arrière                         |
| `origin/main` | Branche `main` sur le dépôt distant `origin` |
| `stash@{0}`   | Dernière remise                              |

---

Retour à la page [Débuter avec Git](README.md).

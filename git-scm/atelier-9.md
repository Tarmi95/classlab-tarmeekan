## Atelier 9 : Faire référence à un projet externe — les sous-modules

## Objectifs

- Comprendre le principe des sous-modules Git.
- Déclarer, cloner et mettre à jour un sous-module.
- Modifier du code dans un sous-module et gérer les conflits.
- Identifier les limites et pièges des sous-modules.

---

### PARTIE 1 — Principe des sous-modules

Un **sous-module** permet d'inclure un dépôt Git dans un autre dépôt Git. Le dépôt parent enregistre uniquement :

- l'URL du sous-module ;
- le **hash du commit exact** auquel le sous-module est épinglé.

```
projet-parent/
├── .gitmodules          ← configuration des sous-modules
├── src/
└── libs/
    └── ma-librairie/    ← dépôt Git indépendant (sous-module)
```

Le dépôt parent ne stocke pas le contenu du sous-module, seulement une référence vers un commit précis.

---

### PARTIE 2 — Préparer les dépôts

Autoriser globalement le protocole file :

```bash
git config --global protocol.file.allow always
```

Crée d'abord une bibliothèque externe (le futur sous-module) :

```bash
mkdir ~/lib_utilitaire && cd ~/lib_utilitaire
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

cat > utils.py << 'EOF'
def addition(a, b):
    return a + b

def soustraction(a, b):
    return a - b
EOF

git add . && git commit -m "feat: fonctions mathématiques v1.0"
git tag -a v1.0 -m "Version 1.0"
```

Crée le projet principal :

```bash
mkdir ~/projet-parent && cd ~/projet-parent
git init
git config user.name "Ton Nom"
git config user.email "ton@email.com"

echo "# Projet principal" > README.md
echo "from libs.lib_utilitaire.utils import addition" > main.py
git add . && git commit -m "feat: initialisation projet"
```

---

### PARTIE 3 — Déclarer un sous-module

Ajoute la bibliothèque comme sous-module dans un dossier `libs/` :

```bash
cd ~/projet-parent
git -c protocol.file.allow=always submodule add ~/lib_utilitaire libs/lib_utilitaire
```

Observe ce que Git a créé :

```bash
cat .gitmodules
git status
ls libs/lib_utilitaire/
```

Le fichier `.gitmodules` contient la configuration :

```
[submodule "libs/lib_utilitaire"]
    path = libs/lib_utilitaire
    url = /root/lib_utilitaire
```

Commite l'ajout du sous-module :

```bash
git add .gitmodules libs/lib_utilitaire
git commit -m "core: ajout sous-module lib_utilitaire"
```

Affiche le commit auquel le sous-module est épinglé :

```bash
git submodule status
```

💡 **Questions :**

- Que contient le fichier `.gitmodules` ?
- Que représente le hash affiché par `git submodule status` ?

---

### PARTIE 4 — Cloner un projet avec sous-modules

Simule le clonage par un nouveau contributeur :

```bash
cd /tmp
git clone ~/projet-parent projet-clone
cd projet-clone
ls libs/lib_utilitaire/   # dossier vide !
```

Le sous-module n'est pas automatiquement récupéré lors d'un `git clone` classique.

Initialise et récupère les sous-modules :

```bash
git submodule init
git submodule update
ls libs/lib_utilitaire/
```

Ou en une seule commande lors du clone :

```bash
git clone --recurse-submodules ~/projet-parent projet-clone-2
ls projet-clone-2/libs/lib_utilitaire/
```

Pour mettre à jour tous les sous-modules d'un dépôt déjà cloné :

```bash
git submodule update --init --recursive
```

**Questions :**

- Que contient le dossier `libs/lib_utilitaire/` avant `git submodule update` ?
- Quelle commande clone le dépôt et ses sous-modules en une seule étape ?

---

### PARTIE 5 — Mettre à jour un sous-module

La bibliothèque a évolué. Publie une nouvelle version :

```bash
cd ~/lib_utilitaire
cat >> utils.py << 'EOF'

def multiplication(a, b):
    return a * b
EOF

git add . && git commit -m "feat: ajout multiplication v1.1"
git tag -a v1.1 -m "Version 1.1"
```

Dans le projet parent, récupère la dernière version du sous-module :

```bash
cd ~/projet-parent
cd libs/lib_utilitaire
git fetch
git checkout v1.1
cd ../..
```

Le dépôt parent voit que le sous-module pointe vers un nouveau commit :

```bash
git status
git diff --cached libs/lib_utilitaire
```

Enregistre la mise à jour dans le projet parent :

```bash
git add libs/lib_utilitaire
git commit -m "core: mise à jour lib_utilitaire vers v1.1"
```

Pour mettre à jour tous les sous-modules vers leur dernière version distante :

```bash
git submodule update --remote
```

**Questions :**

- Pourquoi le projet parent doit-il commiter après la mise à jour d'un sous-module ?
- Quelle différence entre `git submodule update` et `git submodule update --remote` ?

---

### PARTIE 6 — Modifier le code d'un sous-module

Il est possible de contribuer au sous-module directement depuis le projet parent.

Entre dans le sous-module et crée une branche :

```bash
cd ~/projet-parent/libs/lib_utilitaire
git switch -c fix/correction-soustraction

# Corrige une "erreur" dans utils.py
sed -i 's/return a - b/return a - b  # correction/' utils.py
git add . && git commit -m "fix: correction soustraction"
```

Pousse la branche vers le dépôt de la bibliothèque :

```bash
git push origin fix/correction-soustraction
```

Reviens dans le projet parent et mets à jour la référence :

```bash
cd ~/projet-parent
git add libs/lib_utilitaire
git commit -m "core: lib_utilitaire pointe sur fix/correction"
```

**Gérer les conflits sur un sous-module :**

Deux contributeurs ont mis à jour le sous-module vers des commits différents. Lors de la fusion, Git signale un conflit sur le fichier de référence du sous-module.

Résolution :

```bash
# Voir quel commit chaque branche pointe
git diff HEAD MERGE_HEAD -- libs/lib_utilitaire

# Choisir la version à conserver
cd libs/lib_utilitaire
git checkout <hash-voulu>
cd ../..
git add libs/lib_utilitaire
git commit -m "merge: résolution conflit sous-module"
```

**Questions :**

- Si tu modifies le sous-module sans pousser, que se passe-t-il pour les autres membres de l'équipe ?
- Comment savoir si le sous-module a des modifications locales non commitées ?

---

### PARTIE 7 — Supprimer un sous-module

Supprimer un sous-module demande plusieurs étapes manuelles :

```bash
cd ~/projet-parent

# 1. Supprime l'entrée dans .gitmodules
git config -f .gitmodules --remove-section submodule.libs/lib_utilitaire

# 2. Supprime l'entrée dans .git/config
git config --remove-section submodule.libs/lib_utilitaire

# 3. Supprime le dossier du répertoire de travail
rm -rf libs/lib_utilitaire

# 4. Supprime le dossier .git interne du sous-module
rm -rf .git/modules/libs/lib_utilitaire

# 5. Enregistre la suppression
git add .gitmodules
git rm --cached libs/lib_utilitaire
git commit -m "core: suppression sous-module lib_utilitaire"
```

**Question :**

- Pourquoi la suppression d'un sous-module est-elle plus complexe que son ajout ?

---

### PARTIE 8 — Problèmes courants des sous-modules

| Problème                             | Cause                                              | Solution                                        |
| ------------------------------------ | -------------------------------------------------- | ----------------------------------------------- |
| Dossier vide après clone             | `git submodule update` non exécuté                 | `git submodule update --init --recursive`       |
| HEAD détaché dans le sous-module     | Comportement normal de `git submodule update`      | Créer une branche avant de modifier             |
| Sous-module "dirty" bloquant le pull | Modifications locales non commitées                | `git stash` dans le sous-module                 |
| Conflit sur le hash de référence     | Deux branches pointent vers des commits différents | Résoudre manuellement le hash                   |
| Oubli de pousser le sous-module      | Le parent pointe sur un commit non publié          | Toujours pousser le sous-module avant le parent |

**Alternative aux sous-modules :**

Dans de nombreux cas, des alternatives sont préférables :

- **Gestionnaire de paquets** (npm, pip, Maven) : pour les bibliothèques publiques versionnées.
- **git subtree** : intègre l'historique du projet externe directement, plus simple à utiliser au quotidien mais moins isolé.
- **Monorepo** : tous les projets dans un seul dépôt, géré avec des outils comme Nx ou Turborepo.

**Questions :**

- Dans quels cas les sous-modules sont-ils vraiment pertinents par rapport à un gestionnaire de paquets ?
- Quelle commande affiche tous les sous-modules avec leur état (propre, modifié, non initialisé) ?

---

**Atelier terminé ! Félicitations pour ton travail !**

Retour à la page [Débuter avec Git](README.md).

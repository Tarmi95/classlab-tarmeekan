# TP Ansible Collections - Création et publication sur Galaxy

> 🎯 A l'issue de ce TP, vous serez capable de :

- Comprendre la difference entre un role et une collection Ansible
- Creer le squelette d'une collection avec `ansible-galaxy collection init`
- Ecrire un role a l'interieur d'une collection
- Créer un module custom simple en Python
- Construire une collection en `.tar.gz`
- Installer une collection depuis une archive locale
- Utiliser une collection dans un playbook
- Publier une collection sur Ansible Galaxy via GitHub

---

## Contexte

Vous etes administrateur systeme junior chez **InfraCloud**, une entreprise specialisee dans l'hebergement web. Votre equipe gere des dizaines de serveurs (Ubuntu et Rocky Linux) et repete souvent les memes taches : installer des outils de monitoring, configurer des connexions SSH, deployer des paquets de base, etc.

Votre responsable vous demande de **regrouper ces automatisations dans une collection Ansible** propre a l'entreprise. Cette collection sera :

1. **Creee en local** sur le control node Ansible
2. **Testee** sur les managed nodes de l'environnement
3. **Publiee sur Ansible Galaxy** via un depot GitHub pour etre reutilisable par toute l'equipe

**Votre mission** : creer la collection `infracloud.utils`, contenant un role de maintenance serveur et un module custom simple, puis la publier sur Galaxy.

---

## Pré-requis

- Environnement Docker demarre (`make start` depuis la machine hote)
- Connexion SSH au control node : `ssh root@localhost -p 2222` (mot de passe : `P@ssw0rd`)
- Un compte GitHub (gratuit) pour la publication sur Galaxy
- Un compte Ansible Galaxy (https://galaxy.ansible.com) connecte a votre GitHub

---

## Rappel : Role vs Collection

Avant de commencer, clarifions la difference :

|                  | Role                                      | Collection                            |
| ---------------- | ----------------------------------------- | ------------------------------------- |
| **Contenu**      | Taches, handlers, templates, variables    | Roles + modules + plugins + playbooks |
| **Portee**       | Une seule fonction (ex: installer Apache) | Un ensemble de fonctionnalites liees  |
| **Namespace**    | Nom simple (`mon_role`)                   | Namespace.nom (`infracloud.utils`)    |
| **Distribution** | Copie manuelle ou Galaxy (role)           | Galaxy, archives `.tar.gz`, depot Git |
| **Commande**     | `ansible-galaxy role init`                | `ansible-galaxy collection init`      |

> **En resume** : une collection est un **paquet** qui peut contenir plusieurs roles, modules et plugins. C'est le format de distribution recommande par Ansible depuis la version 2.10.

---

## Structure finale attendue

A la fin du TP, vous devez obtenir l'arborescence suivante :

```
/root/projet/collections/
├── infracloud/                             # Repertoire de la collection
│   └── utils/
│       ├── galaxy.yml                      # Metadonnees de la collection
│       ├── README.md                       # Documentation
│       ├── roles/
│       │   └── maintenance/                # Role de maintenance serveur
│       │       ├── defaults/main.yml
│       │       ├── tasks/main.yml
│       │       ├── handlers/main.yml
│       │       ├── templates/
│       │       │   └── motd.j2
│       │       └── meta/main.yml
│       ├── plugins/
│       │   └── modules/
│       │       └── info_serveur.py         # Module custom
│       └── playbooks/
│           └── maintenance_complete.yml    # Playbook inclus dans la collection
├── src/
│   └── infracloud/                         # Repertoire source de développement
│       └── utils/
└── tp-collections.yaml                     # Playbook de test (hors collection)
```

---

## Préparer l’arborescence

```bash
mkdir -p /root/projet/src
mkdir -p /root/projet/collections
cd /root/projet
```

Mettez à jour le fichier `ansible.cfg` du projet en ajoutant :

```ini
collections_path = /root/projet/collections
```

### Vérification

```bash
cd /root/projet
ansible-config dump | grep -i collections
```

Résultat attendu : Ansible doit prendre en compte `/root/projet/collections` comme chemin des collections.

---

## Étape 1 — Créer la collection dans `src/`

Placez-vous dans le dossier source du projet puis initialisez la collection :

```bash
cd /root/projet/src
ansible-galaxy collection init infracloud.utils
```

Vérifiez la structure générée :

```bash
tree /root/projet/src/infracloud/utils
```

Résultat attendu :

```text
/root/projet/src/infracloud/utils/
├── docs/
├── galaxy.yml
├── meta/
│   └── runtime.yml
├── plugins/
│   └── README.md
├── README.md
└── roles/
```

---

## Étape 2 — Configurer `galaxy.yml`

Éditez le fichier :

```bash
vi /root/projet/src/infracloud/utils/galaxy.yml
```

Contenu :

```yaml
---
namespace: infracloud
name: utils
version: 1.0.0
readme: README.md
authors:
  - Votre Nom <votre.email@exemple.com>
description: >-
  Collection utilitaire InfraCloud : maintenance serveur,
  outillage système et module d'information serveur.
license:
  - GPL-3.0-or-later
tags:
  - maintenance
  - linux
  - infrastructure
  - monitoring
dependencies: {}
repository: https://github.com/VOTRE_UTILISATEUR/ansible-collection-infracloud-utils
```

---

## Étape 3 — Créer le rôle `maintenance`

Placez-vous dans la collection source :

```bash
cd /root/projet/src/infracloud/utils
mkdir -p roles/maintenance/{defaults,tasks,handlers,templates,meta}
```

### 3.1 Variables par défaut

Créez `roles/maintenance/defaults/main.yml` :

```yaml
---
# Paquets de base communs
paquets_communs:
  - wget
  - vim
  - tree

# Paquets spécifiques Ubuntu/Debian
paquets_ubuntu:
  - curl
  - htop
  - net-tools
  - software-properties-common

# Paquets spécifiques Rocky/RedHat
paquets_rocky:
  - net-tools
  - htop

# Message du jour (MOTD)
entreprise_nom: "InfraCloud"
environnement: "production"
contact_admin: "admin@infracloud.local"
activer_motd: true
```

### 3.2 Tâches du rôle

Créez `roles/maintenance/tasks/main.yml` :

```yaml
---
# ----------------------------------------------------------
# PARTIE 1 : Mise à jour du cache des paquets
# ----------------------------------------------------------
- name: Mettre à jour le cache APT
  ansible.builtin.apt:
    update_cache: true
    cache_valid_time: 3600
  when: ansible_os_family == "Debian"

- name: Mettre à jour le cache DNF
  ansible.builtin.dnf:
    update_cache: true
  when: ansible_os_family == "RedHat"

# ----------------------------------------------------------
# PARTIE 2 : Rocky - activer EPEL avant d’installer htop
# ----------------------------------------------------------
- name: Installer EPEL sur Rocky/RedHat
  ansible.builtin.dnf:
    name: epel-release
    state: present
  when: ansible_os_family == "RedHat"

- name: Rafraîchir le cache DNF après activation de EPEL
  ansible.builtin.dnf:
    update_cache: true
  when: ansible_os_family == "RedHat"

# ----------------------------------------------------------
# PARTIE 3 : Installer les paquets
# ----------------------------------------------------------
- name: Installer les paquets communs et Ubuntu/Debian
  ansible.builtin.apt:
    name: "{{ paquets_communs + paquets_ubuntu }}"
    state: present
  when: ansible_os_family == "Debian"

- name: Installer les paquets communs et Rocky/RedHat
  ansible.builtin.dnf:
    name: "{{ paquets_communs + paquets_rocky }}"
    state: present
  when: ansible_os_family == "RedHat"

# ----------------------------------------------------------
# PARTIE 4 : Configuration du message du jour (MOTD)
# ----------------------------------------------------------
- name: Déployer le message du jour personnalisé
  ansible.builtin.template:
    src: motd.j2
    dest: /etc/motd
    owner: root
    group: root
    mode: "0644"
  when: activer_motd
  notify: Afficher confirmation MOTD

# ----------------------------------------------------------
# PARTIE 5 : Création du répertoire de logs
# ----------------------------------------------------------
- name: Créer le répertoire de logs applicatif
  ansible.builtin.file:
    path: /var/log/infracloud
    state: directory
    owner: root
    group: root
    mode: "0755"

- name: Créer le fichier de log initial
  ansible.builtin.copy:
    content: |
      # Journal de maintenance InfraCloud
      # Serveur : {{ ansible_hostname }}
      # Initialisé le : {{ ansible_date_time.date }}
    dest: /var/log/infracloud/maintenance.log
    owner: root
    group: root
    mode: "0644"
    force: false

# ----------------------------------------------------------
# PARTIE 6 : Résumé
# ----------------------------------------------------------
- name: Afficher le résumé de la maintenance
  ansible.builtin.debug:
    msg: >-
      Maintenance terminée sur {{ ansible_hostname }}
      ({{ ansible_os_family }})
```

### 3.3 Template MOTD

Créez `roles/maintenance/templates/motd.j2` :

```jinja2
*********************************************
*  Bienvenue sur {{ ansible_hostname }}
*  Entreprise : {{ entreprise_nom }}
*  Environnement : {{ environnement }}
*  OS : {{ ansible_distribution }} {{ ansible_distribution_version }}
*  IP : {{ ansible_default_ipv4.address | default('N/A') }}
*  Contact : {{ contact_admin }}
*********************************************
  Accès réservé au personnel autorisé.
  Toute activité est supervisée.
*********************************************
```

### 3.4 Handler

Créez `roles/maintenance/handlers/main.yml` :

```yaml
---
- name: Afficher confirmation MOTD
  ansible.builtin.debug:
    msg: "Le message du jour a été mis à jour sur {{ ansible_hostname }}"
```

### 3.5 Métadonnées du rôle

Créez `roles/maintenance/meta/main.yml` :

```yaml
---
galaxy_info:
  author: Votre Nom
  description: Rôle de maintenance serveur
  license: GPL-3.0-or-later
  min_ansible_version: "2.14"
  platforms:
    - name: Ubuntu
      versions:
        - focal
        - jammy
    - name: EL
      versions:
        - "8"
        - "9"
dependencies: []
```

---

## Étape 4 — Créer le module custom `info_serveur`

```bash
cd /root/projet/src/infracloud/utils
mkdir -p plugins/modules
vi plugins/modules/info_serveur.py
```

Collez le module suivant :

```python
#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = r'''
---
module: info_serveur
short_description: Collecte des informations de base sur un serveur
version_added: "1.0.0"
description:
  - Retourne le nom d'hôte, le nombre de CPU et, selon les options,
    des informations de mémoire et de disque.
options:
  afficher_memoire:
    description:
      - Inclure la mémoire totale.
    required: false
    type: bool
    default: true
  afficher_disque:
    description:
      - Inclure la taille du disque racine.
    required: false
    type: bool
    default: false
author:
  - Votre Nom (@votre_github)
'''

EXAMPLES = r'''
- name: Collecter les informations du serveur
  infracloud.utils.info_serveur:

- name: Collecter sans la mémoire
  infracloud.utils.info_serveur:
    afficher_memoire: false

- name: Collecter avec le disque
  infracloud.utils.info_serveur:
    afficher_disque: true
'''

RETURN = r'''
hostname:
  description: Nom d'hôte du serveur
  type: str
  returned: always
cpu_count:
  description: Nombre de CPU
  type: int
  returned: always
memoire_totale_mo:
  description: Mémoire totale en Mo
  type: int
  returned: when afficher_memoire is true
disque_racine_go:
  description: Taille du disque racine en Go
  type: float
  returned: when afficher_disque is true
'''

import os
import platform


def get_memoire_totale():
    try:
        with open('/proc/meminfo', 'r') as f:
            for ligne in f:
                if ligne.startswith('MemTotal'):
                    kb = int(ligne.split()[1])
                    return kb // 1024
    except (IOError, IndexError, ValueError):
        return -1
    return -1


def get_espace_disque():
    try:
        stat = os.statvfs('/')
        total_go = (stat.f_blocks * stat.f_frsize) / (1024 ** 3)
        return round(total_go, 2)
    except (OSError, AttributeError):
        return -1


def run_module():
    from ansible.module_utils.basic import AnsibleModule

    module_args = dict(
        afficher_memoire=dict(type='bool', required=False, default=True),
        afficher_disque=dict(type='bool', required=False, default=False),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True,
    )

    resultat = dict(
        changed=False,
        hostname=platform.node(),
        cpu_count=os.cpu_count() or 1,
    )

    if module.params['afficher_memoire']:
        resultat['memoire_totale_mo'] = get_memoire_totale()

    if module.params['afficher_disque']:
        resultat['disque_racine_go'] = get_espace_disque()

    module.exit_json(**resultat)


def main():
    run_module()


if __name__ == '__main__':
    main()
```

---

## Étape 5 — Ajouter un playbook inclus dans la collection

```bash
cd /root/projet/src/infracloud/utils
mkdir -p playbooks
vi playbooks/maintenance_complete.yml
```

Contenu :

```yaml
---
- name: Maintenance complète des serveurs InfraCloud
  hosts: all
  become: true

  tasks:
    - name: Exécuter le rôle de maintenance
      ansible.builtin.include_role:
        name: infracloud.utils.maintenance

    - name: Collecter les informations serveur
      infracloud.utils.info_serveur:
        afficher_memoire: true
        afficher_disque: true
      register: infos

    - name: Afficher le rapport serveur
      ansible.builtin.debug:
        msg: >-
          {{ infos.hostname }} -
          CPU: {{ infos.cpu_count }} |
          RAM: {{ infos.memoire_totale_mo | default('N/A') }} Mo |
          Disque: {{ infos.disque_racine_go | default('N/A') }} Go
```

---

## Étape 6 — Construire l’archive de la collection

La source est dans `src/`, donc le build se fait depuis ce répertoire :

```bash
cd /root/projet/src/infracloud/utils
ansible-galaxy collection build --force
```

Vérifiez l’archive :

```bash
ls -lh /root/projet/src/infracloud/utils/infracloud-utils-*.tar.gz
```

---

## Étape 7 — Installer la collection dans `collections/`

Installez l’archive générée dans le chemin géré par `ansible.cfg` :

```bash
cd /root/projet
ansible-galaxy collection install \
  /root/projet/src/infracloud/utils/infracloud-utils-1.0.0.tar.gz \
  -p /root/projet/collections \
  --force
```

### Vérification sur disque

```bash
tree /root/projet/collections/ansible_collections/infracloud/utils
```

### Vérification logique

```bash
ansible-galaxy collection list -p /root/projet/collections | grep infracloud
```

Résultat attendu :

```text
infracloud.utils  1.0.0
```

---

## Étape 8 — Créer le playbook de test à la racine du projet

Créez le fichier `/root/projet/tp-collections.yaml` :

```yaml
---
- name: TP Collections - Tester le rôle maintenance
  hosts: all
  become: true

  roles:
    - role: infracloud.utils.maintenance

- name: TP Collections - Tester le module info_serveur
  hosts: all
  become: true

  tasks:
    - name: Collecter les informations du serveur
      infracloud.utils.info_serveur:
        afficher_memoire: true
        afficher_disque: true
      register: infos_serveur

    - name: Afficher les informations collectées
      ansible.builtin.debug:
        msg: |
          === Rapport serveur ===
          Nom : {{ infos_serveur.hostname }}
          CPU : {{ infos_serveur.cpu_count }}
          RAM : {{ infos_serveur.memoire_totale_mo | default('N/A') }} Mo
          Disque : {{ infos_serveur.disque_racine_go | default('N/A') }} Go
```

### Pourquoi cette écriture est préférable

On utilise ici le **FQCN du rôle** :

```yaml
infracloud.utils.maintenance
```

Cela évite les ambiguïtés de recherche sur les rôles et rend le chargement plus explicite.

---

## Étape 9 — Tester le TP

Lancez le playbook depuis la racine du projet :

```bash
cd /root/projet
ansible-playbook -i /root/projet/inventaire tp-collections.yaml
```

### Vérifications attendues

- le rôle installe les paquets de base ;
- le fichier `/etc/motd` est déployé ;
- le répertoire `/var/log/infracloud/` existe ;
- le module `infracloud.utils.info_serveur` retourne les informations système.

### Contrôle sur un nœud cible

```bash
ssh root@client1
cat /etc/motd
ls -la /var/log/infracloud/
exit
```

---

## Étape 10 — Publier sur GitHub et Galaxy

La logique ne change pas, mais le dépôt Git doit maintenant être initialisé dans **la source** :

```bash
cd /root/projet/src/infracloud/utils
git init
git branch -M main
```

### `.gitignore` conseillé

```gitignore
*.tar.gz
*.pyc
__pycache__/
.DS_Store
*.swp
```

### Premier commit

```bash
git add .
git commit -m "feat: initialisation collection infracloud.utils v1.0.0"
```

### Remote GitHub

```bash
git remote add origin https://github.com/VOTRE_UTILISATEUR/ansible-collection-infracloud-utils.git
git push -u origin main
```

### Tag de version

```bash
git tag -a v1.0.0 -m "Version 1.0.0 - release initiale"
git push origin v1.0.0
```

### Publication Galaxy

```bash
cd /root/projet/src/infracloud/utils
ansible-galaxy collection build --force
ansible-galaxy collection publish infracloud-utils-1.0.0.tar.gz --api-key VOTRE_TOKEN_API
```

---

## Etape 11 - Verifier et installer depuis Galaxy

### 11.1 - Rechercher la collection sur Galaxy

Visitez directement : `https://galaxy.ansible.com/infracloud/utils`

### 11.2 - Installer depuis Galaxy (simulation)

Pour verifier que l'installation fonctionne, desinstallez d'abord la version locale puis reinstallez depuis Galaxy :

```bash
# Supprimer la version locale
rm -rf /root/projet/collections/ansible_collections/infracloud

# Installer depuis Galaxy
ansible-galaxy collection install infracloud.utils -p /root/projet/collections
```

### 11.3 - Utiliser un fichier requirements.yml

En entreprise, on utilise un fichier `requirements.yml` pour gerer les collections d'un projet :

```bash
cd /root/projet/collections
vi requirements.yml
```

```yaml
---
collections:
  - name: infracloud.utils
    version: ">=1.0.0"
  # Exemples d'autres collections populaires :
  # - name: community.general
  #   version: ">=7.0.0"
  # - name: ansible.posix
  #   version: ">=1.5.0"
```

Installez toutes les collections du projet en une commande :

```bash
ansible-galaxy collection install -r requirements.yml -p /root/projet/collections
```

---

## Etape 12 - Mettre a jour la collection (cycle de vie)

Votre responsable vous demande d'ajouter une fonctionnalite : le role doit aussi configurer le fuseau horaire des serveurs.

### 12.1 - Ajouter la fonctionnalite

Modifiez le fichier des variables par defaut :

```bash
cd /root/projet/collections/infracloud/utils
vi roles/maintenance/defaults/main.yml
```

Ajoutez à la fin du fichier :

```yaml
# Configuration du fuseau horaire
fuseau_horaire: "Europe/Paris"
```

Ajoutez une tache dans le fichier de taches du role :

```bash
vi roles/maintenance/tasks/main.yml
```

Ajoutez à la fin du fichier, avant la tache de resumé :

```yaml
# ----------------------------------------------------------
# PARTIE 6 : Configuration du fuseau horaire
# ----------------------------------------------------------
- name: Configurer le fuseau horaire
  ansible.builtin.command:
    cmd: "timedatectl set-timezone {{ fuseau_horaire }}"
  changed_when: true
```

### 12.2 - Incrementer la version

Ouvrez `galaxy.yml` et changez la version :

```bash
vi galaxy.yml
```

Modifiez la ligne :

```yaml
version: 1.1.0
```

> **Rappel Semantic Versioning** :
>
> - Correctif (bug fix) : `1.0.0` → `1.0.1`
> - Nouvelle fonctionnalite (retro-compatible) : `1.0.0` → `1.1.0`
> - Changement majeur (non retro-compatible) : `1.0.0` → `2.0.0`

### 12.3 - Construire, committer et publier la mise a jour

```bash
# Build de la nouvelle version
ansible-galaxy collection build --force

# Commit et tag Git
git add .
git commit -m "feat: ajout configuration fuseau horaire (v1.1.0)"
git tag -a v1.1.0 -m "Version 1.1.0 - Ajout configuration fuseau horaire"
git push origin main --tags

# Publication sur Galaxy
ansible-galaxy collection publish infracloud-utils-1.1.0.tar.gz --api-key VOTRE_TOKEN_API
```

---

## Etape 13 - Utiliser un fichier de vault password pour l'API Token

Pour eviter de taper votre token API Galaxy a chaque publication, vous pouvez le stocker de maniere securisee :

```bash
# Creer un fichier contenant le token (remplacez par votre vrai token)
echo "VOTRE_TOKEN_API" > ~/.galaxy_token

# Restreindre les permissions
chmod 600 ~/.galaxy_token

# Publier en utilisant le fichier
ansible-galaxy collection publish infracloud-utils-1.1.0.tar.gz --token "$(cat ~/.galaxy_token)"
```

> **Securite** : n'oubliez pas d'ajouter `~/.galaxy_token` dans votre `.gitignore` global pour ne jamais le commiter accidentellement.

---

## Resumé des commandes utilisées

### Commandes Collections

| Commande                                                           | Description                                |
| ------------------------------------------------------------------ | ------------------------------------------ |
| `ansible-galaxy collection init namespace.nom`                     | Creer le squelette d'une collection        |
| `ansible-galaxy collection build`                                  | Construire l'archive `.tar.gz`             |
| `ansible-galaxy collection install archive.tar.gz -p chemin`       | Installer depuis une archive locale        |
| `ansible-galaxy collection install namespace.nom`                  | Installer depuis Galaxy                    |
| `ansible-galaxy collection install -r requirements.yml`            | Installer depuis un fichier de dependances |
| `ansible-galaxy collection list`                                   | Lister les collections installees          |
| `ansible-galaxy collection publish archive.tar.gz --api-key TOKEN` | Publier sur Galaxy                         |

### Structure d'une collection

| Repertoire/Fichier   | Contenu                                       |
| -------------------- | --------------------------------------------- |
| `galaxy.yml`         | Metadonnees (namespace, nom, version, auteur) |
| `roles/`             | Roles inclus dans la collection               |
| `plugins/modules/`   | Modules custom en Python                      |
| `plugins/inventory/` | Plugins d'inventaire custom                   |
| `plugins/callback/`  | Plugins de callback custom                    |
| `playbooks/`         | Playbooks reutilisables                       |
| `docs/`              | Documentation supplementaire                  |
| `meta/runtime.yml`   | Configuration du runtime Ansible              |

### Nomenclature des collections

| Element      | Format                      | Exemple                               |
| ------------ | --------------------------- | ------------------------------------- |
| Namespace    | minuscules, underscores     | `infracloud`                          |
| Nom          | minuscules, underscores     | `utils`                               |
| FQCN Module  | `namespace.nom.module`      | `infracloud.utils.info_serveur`       |
| FQCN Role    | `namespace.nom.role`        | `infracloud.utils.maintenance`        |
| Depot GitHub | `ansible-collection-NS-NOM` | `ansible-collection-infracloud-utils` |
| Archive      | `NS-NOM-VERSION.tar.gz`     | `infracloud-utils-1.0.0.tar.gz`       |

---

## Atelier autonome : créer une collection de votre choix

Après avoir reproduit l’exemple `infracloud.utils`, vous allez créer **votre propre collection Ansible** sur un thème libre. Cette partie permet de vérifier que vous avez compris la logique d’une collection et que vous êtes capable de la réappliquer.

### Objectif pédagogique

Vous devez concevoir une collection utile, cohérente et testable, avec :

- un **namespace** de votre choix ;
- un **nom de collection** de votre choix ;
- au moins **un rôle** ;
- au moins **un module custom** ou **un second rôle** ;
- un **playbook de test** ;
- une **documentation minimale**.

### Exemples de thèmes possibles

- `ecole.outils` : outils utiles pour des postes pédagogiques ;
- `entreprise.supervision` : supervision légère et diagnostics ;
- `startup.web` : préparation de serveurs web ;
- `campus.utilisateurs` : gestion simple d’utilisateurs et de groupes ;
- `infra.securite` : durcissement basique de connexion ;
- `labs.docker` : prérequis pour des serveurs de TP Docker.

### Contraintes attendues

Votre collection doit respecter la structure projet suivante :

```text
/root/projet/
├── ansible.cfg
├── collections/
│   └── ansible_collections/
│       └── <namespace>/
│           └── <nom_collection>/
├── src/
│   └── <namespace>/
│       └── <nom_collection>/
└── tp-collections.yaml
```

### Définir votre idée avant de créer les fichiers

Avant toute commande, rédigez en quelques lignes :

- le **nom complet** de votre collection : `namespace.nom` ;
- le **besoin couvert** ;
- la **cible** : quel type de serveur ou quel contexte ? ;
- les **actions réalisées** par le rôle principal ;
- les **paramètres configurables** prévus dans `defaults/main.yml`.

---

### Atelier terminé ! Félicitations !!!

[Retour à la page démarrer avec Ansible](../README.md)

## 📚 Pour aller plus loin

- [Documentation Ansible](https://docs.ansible.com/)
- [Retour en arrière](../README.md)

---

## Atelier 1 : Premiers pas avec GitLab CI

## Objectifs

- Comprendre le principe de l'intégration continue (CI) et du déploiement continu (CD).
- Créer et exécuter son premier pipeline GitLab.
- Utiliser les concepts de stages, jobs, scripts et artifacts.

---

### 1 Créer un Nouveau Projet GitLab

- Connectes-toi à GitLab.
- Dans un groupe, crées un projet en selectionnant **"Create Blank Project"**, nommé `atelier-ci-cd`.
- Laisses le projet **Public** ou **Private** selon ton choix.

---

### 2 Créer le fichier `.gitlab-ci.yml`

_C’est le fichier de configuration qui décrit les étapes d’un pipeline CI/CD (Continuous Integration / Continuous Deployment) pour GitLab._

- Dans le projet à la racine de ton dépôt GitLab, ajoutes le fichier nommé `.gitlab-ci.yml` et colles le contenu suivant d'un job de build :

```yaml
build:
  image: alpine
  script:
    - echo "Build en cours..."
    - mkdir build
    - echo "Ceci est un fichier de build." > build/info.txt
```

- Valides en cliquant sur `Commit Changes`

---

### 3 Lancer et Observer le Pipeline

- Rendez-vous dans **"Build" > "Pipelines"**.
- Lances manuellement le pipeline si besoin (sinon il démarre automatiquement).
- Observes le job et cliques dessus pour voir les détails d'exécution et les logs.

---

### 4 Ajouter un job de test

Ajoutes un job de test afin de verifier automatiquement le bon fonctionnement de job de build (la présence du fichier _`build/info.txt`_).

- Dans le projet à la racine de ton dépôt GitLab, modifies `.gitlab-ci.yml` et colles le contenu suivant :

```yaml
build:
  image: alpine
  script:
    - echo "Compilation en cours..."
    - mkdir build
    - echo "Ceci est un fichier de build." > build/info.txt

test:
  image: alpine
  script:
    - echo "Running tests..."
    - test -f "build/info.txt"
    - cat info.txt
```

- Valides en cliquant sur `Commit Changes`
- Rendez-vous dans **"Build" > "Pipelines"**.
- Lances manuellement le pipeline si besoin (sinon il démarre automatiquement).
- Observes les jobs et cliques dessus pour voir les détails d'exécution et les logs.

**Question :**

- Pourquoi le job `test` échoue ?

---

### 5 Ajouter des stages

Définir les grandes étapes du pipeline CI/CD.

- Dans le projet à la racine de ton dépôt GitLab, modifies `.gitlab-ci.yml` et colles le contenu suivant :

```yaml
stages:
  - build
  - test

build:
  image: alpine
  stage: build
  script:
    - echo "Compilation en cours..."
    - mkdir build
    - echo "Ceci est un fichier de build." > build/info.txt

test:
  image: alpine
  stage: test
  script:
    - echo "Running tests..."
    - test -f "build/info.txt"
    - cat info.txt
```

- Valides en cliquant sur `Commit Changes`
- Observes les jobs et cliques dessus pour voir les détails d'exécution et les logs.

**Questions :**

- Que constates-tu au niveau des jobs ?
- Pourquoi le job `test` continue d'échouer ? Que faudrait-il corriger ?

---

### 6 Corriger le job en echec

- Dans le projet à la racine de ton dépôt GitLab, modifies `.gitlab-ci.yml` afin de corriger le job en echec.
- Valides en cliquant sur `Commit Changes`
- Observes les jobs et cliques dessus pour voir les détails d'exécution et les logs.

---

**Atelier terminé ! Félicitations pour ton travail !**

Retour à la page [Débuter avec GitLab](README.md).


# Atelier 19 : Helm

> 🎯 **Dans cet atelier, vous allez explorer Helm.**  


## PARTIE 1. Le gestionnaire de paquets pour Kubernetes

`Helm` est comme les gestionnaires de paquets l’équivalent de `APT` ou `YUM` ou `DNF` mais pour Kubernetes.
De la même façon qu’APT vous aide à gérer les paquets logiciels sur un système Linux, Helm vous aide à gérer les applications sur un cluster Kubernetes.

#### 1. Comment fonctionne `Helm`

Sous Linux, vous utilisez APT pour installer un logiciel comme nginx en exécutant :


```
sudo apt install nginx
```

Cela récupère le paquet nginx depuis un dépôt, l’installe et le configure sur votre système.

Dans Kubernetes, vous utilisez Helm pour installer des applications comme nginx en exécutant :

```
helm install mon-nginx bitnami/nginx
```

Cela récupère un chart Helm nginx depuis un dépôt de charts, crée les ressources Kubernetes nécessaires (comme les déploiements, services), et déploie l’application dans votre cluster.

#### 2. Pourquoi utiliser `Helm` ?

- Gestion de paquets

`APT` gère les paquets DEB (comme les fichiers .deb) sous Linux.

`Helm` gère les Charts Helm (fichiers YAML regroupés) dans Kubernetes.

- Gestion des versions

`APT` peut installer une version spécifique d’un paquet avec :

```
sudo apt install nginx=1.28.0
```

Helm peut faire la même chose :

```
helm install mon-nginx bitnami/nginx --version 21.1.23
```

Cela signifie que vous pouvez facilement rétrograder ou mettre à jour vos applications.

- Gestion de la configuration

Avec APT, vous configurez les logiciels via des fichiers de configuration (comme ***/etc/nginx/nginx.conf***).

Avec Helm, vous pouvez surcharger les valeurs de configuration à l’aide d’un fichier YAML :

```
helm install mon-nginx bitnami/nginx --values custom-values.yaml
```

Cela vous permet de personnaliser la manière dont l’application est déployée.

- Gestion des dépendances

`APT` résout automatiquement les dépendances entre paquets.

`Helm` gère les dépendances entre composants Kubernetes, comme s’assurer qu’une base de données est prête avant de déployer une application web.

---

## PARTIE 2. Les composants de Helm

`Helm` est constitué de plusieurs composants qui travaillent ensemble pour simplifier le déploiement et la gestion d’applications sur Kubernetes.

#### 1. Helm CLI

Le CLI Helm est l’outil en ligne de commande utilisé pour interagir avec Helm.

C’est ce que vous exécutez lorsque vous tapez des commandes comme :

```bash
helm install mon-app mon-chart/
```

Il communique avec Kubernetes pour créer, mettre à jour ou supprimer des ressources.

#### 2. Charts

Un Chart Helm est un paquet qui contient toutes les définitions de ressources Kubernetes nécessaires pour exécuter une application.


Chaque chart est un ensemble de fichiers YAML organisés avec une structure spécifique.


Exemple : un chart Nginx peut inclure un Deployment, un Service, et un ConfigMap.


#### 3. Releases

Une release est une instance d’un chart déployée dans un cluster Kubernetes.

Exemple : si vous installez deux fois le même chart Nginx avec des noms différents (mon-nginx, test-nginx), vous aurez deux releases.

Chaque release est gérée et suivie séparément.


#### 4. Dépôt de Charts

Un dépôt Helm est comme une bibliothèque de charts.

C’est un emplacement (par ex. une URL) où les charts Helm sont stockés et partagés.

Exemples : Artifact Hub, Dépôt Bitnami...

Vous pouvez ajouter un dépôt avec :

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

---

## PARTIE 3. Deployer Chart `Helm`

#### 1. Installer `NGINX` avec `Helm`

Pour déployer NGINX, nous allons utiliser le chart Helm Bitnami.

- Ajouter le dépôt Bitnami :

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

- Installer le chart Helm NGINX :

```bash
helm install mon-nginx bitnami/nginx
```

- Vérifier l’installation :

```bash
helm list
kubectl get pods
```

- Personnaliser pendant l’installation

  - Pour voir les valeurs disponibles à la personnalisation, exécutez :

      ```bash
    helm show values bitnami/nginx
    ```

  - Pour prévisualiser le manifeste sans le déployer :

      ```bash
    helm template mon-nginx bitnami/nginx
    ```

#### 2. Mettre à jour `NGINX` avec `Helm`

Pour mettre à jour la release NGINX, on peut modifier des paramètres ou mettre à jour la version du chart.

- Mettre à jour la release :

```bash
helm upgrade mon-nginx bitnami/nginx --set service.type=NodePort
```

- Vérifier l’état après mise à jour :

```bash
helm status mon-nginx
```

#### 3. Désinstaller `NGINX` avec `Helm`

Pour supprimer la release NGINX du cluster :

- Désinstaller la release :

```bash
helm uninstall mon-nginx
```

- Vérifier la désinstallation :

```bash
helm list
kubectl get pods
```
---

## PARTIE 4. Création de dépôt `Helm`

#### 1. Créer un chart `Helm`

- Créer la structure de répertoires :

- Générer le chart Helm

#### 2. Personnaliser le chart `Helm`

- Modifier values.yaml

- Modifier templates/deployment.yaml

#### 3. Héberger le dépôt `Helm` sur GitLab 

- Créer un dépôt GitLab :

- Initialiser le dépôt Git :

- Pousser le chart vers GitLab :

#### 4. Utiliser le dépôt `Helm`

- Ajouter le dépôt Helm :

- Rechercher les charts disponibles

- Installer un service


---

### 💡 A savoir

Kubernetes est un système complexe avec de nombreux éléments (Pods, Deployments, Services, etc.).

**Helm simplifie ce processus en regroupant tout dans des charts réutilisables**.

C’est comme avoir **un installeur en un clic** pour toute votre pile applicative au lieu de devoir créer manuellement chaque composant.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-20-kuztomize.md)

[Revenir à l'atelier precedent](atelier-18-autoscaling.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Helm](https://helm.sh/)
- [Documentation ArtifactHUB](https://artifacthub.io/)
- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



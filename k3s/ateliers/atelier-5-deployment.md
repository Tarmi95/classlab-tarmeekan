
# Atelier 5 : Deployment 

> 🎯 **Dans cet atelier, nous allons explorer Deployment Kubernetes pour gérer le cycle de vie de notre application.**  


## PARTIE 1. Création d’un `Deployment` dans Kubernetes  

Comment créer un Deployment Kubernetes pour gérer le cycle de vie de notre application, en utilisant un conteneur NGINX. Le processus consiste à rédiger un fichier YAML décrivant la configuration du déploiement, à l'appliquer et à surveiller l'état du déploiement. 

#### 1. Créer un dossier de projet `deployment`:

#### 2. Créer le fichier `nginx-deployment.yaml` :

#### 3. Rédiger la configuration du Deployment:

Complétez votre fichier `nginx-deployment.yaml` avec la structure suivante :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.28.0
          ports:
            - containerPort: 80
  strategy:
    type: RollingUpdate
```

#### 4. Appliquer le Deployment :

```bash
kubectl apply -f nginx-deployment.yaml
```

#### 5. Vérifier le statut du Deployment :

```bash
kubectl get deployments
```

#### 6. Décrire le Deployment :

```bash
kubectl describe deployment nginx-deployment
```

#### 7. Examiner les Pods :

```bash
kubectl get pods
```

#### 8. Afficher la configuration d'un Pod :

```bash
kubectl get pod <nom-du-pod> -o yaml
```

---

## PARTIE 2. `Deployment` : Mise à jour d'un Pod Template dans Kubernetes

Dans cette partie, nous nous concentrerons sur la mise à jour d'un **Pod Template** dans Kubernetes, en passant d’une ancienne version d’image à une nouvelle.


#### 1. Mettre à jour l’image :  
Dans `nginx-deployment.yaml` modifiez la ligne déclarant l'image et remplacez :
```yaml
image: nginx:1.28.0
```
par :
```yaml
image: nginx:1.28.0-alpine
```

#### 2. Identifier les changements :  
Exécutez la commande suivante pour voir les différences sans appliquer les modifications :
```bash
kubectl apply --dry-run=client -f nginx-deployment.yaml
```

#### 3. Préparer le terminal :  
Divisez votre terminal en plusieurs sessions :
- l’une pour surveiller les Pods (`kubectl get pods --watch`),  
- une autre pour surveiller les ReplicaSets (`kubectl get rs --watch`),  
- et une pour exécuter les commandes.

#### 4. Appliquer les modifications :

```bash
kubectl apply -f nginx-deployment.yaml
```

#### 5. Surveiller la mise à jour :  
Observez les logs et l’évolution des Pods et ReplicaSets dans les fenêtres de surveillance.

#### 5. Décrire le Deployment :

```bash
kubectl describe deployment nginx-deployment
```

#### 6. Vérifier la nouvelle image :  
Listez les Pods puis décrivez-en un pour confirmer l'image :
```bash
kubectl get pods
kubectl describe pod <nom-du-pod> | grep Image
```

---

## PARTIE 3. Rollouts de Deployment

Un  `rollout` est le **processus de mise à jour** des pods d’un Deployment, par exemple lors du passage de `nginx:1.28.0` à `nginx:1.28.0-alpine`.

Kubernetes gère le `rollout` de façon **progressive** pour éviter de couper tout le service en même temps.

### Stratégies de rollout 
#### RollingUpdate (par défaut) :

- Kubernetes arrête progressivement de vieux pods et crée de nouveaux pods avec la nouvelle version, tout en garantissant qu’un certain nombre d’anciens pods reste disponible.

#### Recreate :

- Kubernetes supprime tous les pods existants avant de créer les nouveaux. (Moins utilisé en production, car cela provoque une interruption de service.)


Dans cette paartie, nous allons découvrir les opérations essentielles que vous pouvez effectuer lors d’un `rollout`, notamment comment consulter l’historique, annuler des modifications et annoter vos déploiements.

#### 1. Vérifier votre déploiement 
Assurez-vous que `nginx-deployment` est `Available`.
```bash
kubectl get deployment
```
   
#### 2. Consulter l’historique des rollouts  
```bash
kubectl rollout history deployment nginx-deployment
```

#### 3. Annuler un rollout
Pour revenir à la révision précédente :
```bash
kubectl rollout undo deployment nginx-deployment
```

#### 4. Afficher les détails d’une révision (exemple : revision=2)
```bash
kubectl rollout history deployment nginx-deployment --revision=2
```

#### 5. Ajouter une annotation
Modifiez `nginx-deployment.yaml` pour inclure :
```yaml
metadata:
  annotations:
    kubernetes.io/change-cause: "Mise à jour de nginx vers la version 1.28.0-alpine"
```
- Puis réappliquez :
```bash
kubectl apply -f nginx-deployment.yaml
```

cVérifier les annotations 
```bash
kubectl describe deployment nginx-deployment
```
Regardez la section `Annotations` pour confirmer.


## PARTIE 4. Mise à l’échelle des Deployments

Dans cette partie, nous allons explorer comment utiliser la commande `kubectl scale` pour ajuster dynamiquement le nombre de réplicas d’un deployment Kubernetes. La capacité de scaler vos applications est essentielle pour gérer efficacement les ressources. 

#### 1.  Afficher les deployments
```bash
kubectl get deployment
```
Notez le nombre actuel de réplicas.

#### 2. Mettre à l’échelle
```bash
kubectl scale deployment nginx --replicas=3
```
Ajustez le nombre selon vos besoins.

#### 3. Vérifier la mise à l’échelle
```bash
kubectl get deployment
```
Vous devriez voir le nombre de réplicas mis à jour.

#### 4. Rétablir l’état d’origine 
Appliquer votre fichier de configuration remettra les réplicas à la valeur définie dans celui-ci :
```bash
kubectl apply -f nginx-deployment.yaml
```

#### 5. Cas spécial – récupération de pods
Si vos pods sont défaillants, vous pouvez faire :
```bash
kubectl scale deployment nginx --replicas=0
kubectl scale deployment nginx --replicas=5
```

#### 6. Nettoyage
```bash
kubectl delete -f nginx-deployment.yaml
```

### 💡 A savoir

La mise à l’échelle des deployments est importante pour gérer les ressources et la charge de travail de vos applications. Bien que `kubectl scale` soit utile pour des ajustements rapides, assurez-vous de maintenir vos fichiers de configuration (manifests) à jour pour conserver la cohérence.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-6-service.md)

[Revenir à l'atelier precedent](atelier-4-replicasets.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://www.docker.com/)
- [Documentation K3S](https://k3s.io/)



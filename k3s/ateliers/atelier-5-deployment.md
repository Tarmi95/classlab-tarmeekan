
# Atelier 5 : Deployment 

> 🎯 **Dans cet atelier, nous allons explorer comment créer un Deployment Kubernetes pour gérer le cycle de vie de notre application, en utilisant un conteneur NGINX. Le processus consiste à rédiger un fichier YAML décrivant la configuration du déploiement, à l'appliquer et à surveiller l'état du déploiement.**  


## PARTIE 1. Création d’un `Deployment` dans Kubernetes  

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

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-5-deployment.md)

[Revenir à l'atelier precedent](atelier-4-replicasets.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://www.docker.com/)
- [Documentation K3S](https://k3s.io/)




# Atelier 4 : ReplicaSet 

> 🎯 **Dans cet atelier, nous allons découvrir comment créer un ReplicaSet dans Kubernetes pour gérer un nombre défini de répliques de pods. Le ReplicaSet assure que le nombre souhaité de pods est toujours en cours d’exécution.**  


## PARTIE 1. Création d’un `ReplicaSet` dans Kubernetes  

#### 1. Supprimer les ressources en cours d'execution :
```bash
kubectl delete pod nginx-pod
kubectl delete svc nginx-pod
```

#### 2. Créer un dossier de projet nommé `replicasets` 

#### 3. Rédiger le fichier `nginx-rs.yaml`
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
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
```

#### 4. Appliquer la configuration
```bash
kubectl apply -f nginx-rs.yaml
```

#### 5. Vérifier le ReplicaSet et les Pods
```bash
kubectl get replicaset
kubectl get pods
```

#### 5. Tester l’auto-réparation 

Supprimez un pod manuellement :

```bash
kubectl delete pod <nom_du_pod>
```
Observez la recréation automatique d’un nouveau pod.

---

## PARTIE 2. Les limites de la mise à jour des Pods avec ReplicaSets

#### 1. Vérifier les pods et le ReplicaSet
```bash
kubectl get pods
kubectl get replicaset
```

#### 2. Mettre à jour l’image
Ouvrez votre fichier ReplicaSet `nginx-rs.yaml` et changer l’image de `nginx:1.28.0` → `nginx:1.28.0-alpine`.

#### 3. Appliquer les changements
```bash
kubectl apply -f nginx-rs.yaml
```

#### 4. Surveiller les changements
Dans un autre terminal :
```bash
kubectl get pods --watch
kubectl get replicaset --watch
```

#### 5. Vérifier l’image utilisée
```bash
kubectl describe pod <nom_du_pod> | grep Image
```

#### 6. Supprimer les pods existants
```bash
kubectl delete pod <nom_du_pod>
```
Un nouveau pod sera créé automatiquement avec la nouvelle image.

### 💡 A savoir
Vous avez découvert que la mise à jour d’un ReplicaSet nécessite la suppression manuelle des pods existants pour appliquer les nouvelles modifications. Pour simplifier les mises à jour, il est préférable d’utiliser un **Deployment**, qui gère automatiquement ces opérations.

---

## PARTIE 3. Limites des ReplicaSets et Pods existants dans Kubernetes

#### 1. Rédiger un nouveau fichier `nginx-extra-pod.yaml` pour le pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-extra
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.28.0
      ports:
        - containerPort: 80
```

#### 2. Créer le pod
```bash
kubectl apply -f nginx-extra-pod.yaml
```

#### 3. Surveiller le ReplicaSet et les pods 
```bash
kubectl get replicaset
kubectl get pods --watch
```

#### 4. Observer le comportement 
Le ReplicaSet supprimera automatiquement le pod en excès pour respecter le nombre réplicas défini.

#### 6. Supprimer le pod
```bash
kubectl delete pod nginx-extra
```
---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-05-deployment.md)

[Revenir à l'atelier precedent](atelier-03-manifests_kubernetes.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



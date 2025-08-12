
# Atelier 3 : Les manifests de kubernetes

> 🎯 **Un manifest est un fichier au format YAML (ou JSON) qui déclare un ou plusieurs objets Kubernetes (Pod, ReplicaSet, Deployment, Service, etc). Dans cet atelier, nous explorons Kubernetes en apprenant comment créer et gérer des pods NGINX en utilisant l'approche impérative et déclarative avec fichier de configuration (manifest).**  


## PARTIE 1. Création de `pod`  en utilisant l'approche impérative avec manifest

#### 1.  Créer un nouveau dossier pour votre projet (par exemple `manifests-kubernetes`)

#### 2. Générer le manifest d’un `Pod` nommé `nginx-pod` sans le créer réellement sur le cluster, et de sauvegarder ce manifest dans un fichier `nginx-pod.yaml` :
```bash
kubectl run nginx-pod --image=nginx:1.28.0 --port=80 --dry-run=client -o yaml > nginx-pod.yaml
```

#### 3. Adapter le manifest `nginx-pod.yaml` comme ci-dessous  :
```bash
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: nginx
  name: nginx-pod
spec:
  containers:
  - image: nginx:1.28.0
    name: nginx-conteneur
    ports:
    - containerPort: 80
```

#### 4. Créer le Pod :
```bash
kubectl create -f nginx-pod.yaml
```

#### 5. Vérifier le Pod  :
- Listez les pods :

```bash
kubectl get pods
```

- Obtenez plus de détails :

```bash
kubectl describe pod nginx-pod
```

---

## PARTIE 2. Exposer le Pod à l'exterieur via un Service en utilisant l'approche impérative avec manifest

#### 1. Générer le manifest d’un `Service` nommé `nginx` sans le créer réellement sur le cluster, et de sauvegarder ce manifest dans un fichier `nginx-svc.yaml` :
```bash
kubectl expose pod nginx-pod --type=NodePort --port=80 --dry-run=client -o yaml > nginx-svc.yaml
```

#### 3. Adapter le manifest `nginx-svc.yaml` comme ci-dessous  :
```bash
apiVersion: v1
kind: Service
metadata:
  labels:
    app: nginx
  name: nginx-pod
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: NodePort
```

#### 4. Créer le Service :
```bash
kubectl create -f nginx-svc.yaml
```

#### 5. Vérifier le Service  :
- Listez les services :

```bash
kubectl get svc
```

- Obtenez plus de détails :

```bash
kubectl describe svc nginx-svc
```

---

## PARTIE 3. Les limites de l'approche impérative avec manifest

#### 1. Examiner la configuration actuelle :
```bash
kubectl describe pod nginx-pod
```

#### 2. Modifier le fichier de configuration :

Ouvrez votre fichier `nginx-pod.yaml` et changez l’image de `1.28.0` à la version `1.28.0-alpine`.


#### 3. Tenter la mise à jour :
```bash
kubectl replace -f nginx-pod.yaml
```

#### 4. Analyser l’erreur :

Si une erreur survient concernant des champs non modifiables, notez le message indiquant les champs manquants ou interdits.

#### 5. Supprimer et recréer le pod :
```bash
kubectl delete pod nginx-pod
kubectl create -f nginx-pod.yaml
```

#### 6. Vérifier la modification :
```bash
kubectl describe pod nginx-pod
```

#### 7. Supprimer les ressources.


## PARTIE 4. L'approche déclarative avec manifest

#### 1. Créer le pod `nginx-pod` en utilisant l'approche déclarative avec le manifest `nginx-pod.yaml` :
```bash
kubectl apply -f nginx-pod.yaml
```

#### 2. Vérifier la creation :
```bash
kubectl get pods
```

#### 3. Mettre à jour le pod

- Modifiez le fichier `nginx-pod.yaml` pour changer la version de l’image de `1.28.0` → `1.28.0-alpine`.

- Appliquez à nouveau :

```bash
kubectl apply -f nginx-pod.yaml
```

#### 4. Visualiser les différences :
```bash
kubectl diff -f nginx-pod.yaml
```

#### 5. Supprimer les ressources :
```bash
kubectl delete -f nginx-pod.yaml
```

#### 6. Gérer plusieurs objets :
```bash
kubectl apply -f .
```

#### 7. Supprimer les ressources.

---

## PARTIE 5. Migration de l'approche imperative vers la déclarative avec manifest

#### 1. Créer un Pod :
```bash
kubectl create -f nginx-pod.yaml
```

#### 2. Vérifier la création du Pod :
```bash
kubectl get pods
```

#### 3. Appliquer la configuration :
```bash
kubectl apply -f nginx-pod.yaml
```

#### 4. Vérifier la dernière configuration appliquée :
```bash
kubectl get pod nginx -o yaml
```

Recherchez l’annotation `kubectl.kubernetes.io/last-applied-configuration`.

#### 5. Supprimer le pod :

```bash
kubectl delete -f nginx-pod.yaml
```

### 💡 A savoir
En passant de commandes **impératives** à **`kubectl apply`**, vous adoptez une approche déclarative qui permet à Kubernetes de conserver la dernière configuration appliquée et de gérer les mises à jour de manière plus fluide.

---

## PARTIE 6. Gérer plusieurs objets Kubernetes dans un seul fichier

#### 1. Créer un nouveau fichier, `nginx.yaml`

#### 2. Définir le Pod `nginx-pod`
Copier la définition du pod, c'est à dire le contenu de `nginx-pod.yaml` dans ce fichier `nginx.yaml`.

#### 3. Séparer avec `---`
Ajouter trois tirets pour indiquer un nouvel objet.

#### 4. Définir le Service `nginx-svc`
Copier la définition du svc, c'est à dire le contenu de `nginx-svc.yaml` dans ce fichier `nginx.yaml`.

#### 5. Enregistrer le fichier
Assurez-vous que `nginx.yaml` est enregistré

#### 6. Vérifier l’absence de ressources existantes
```bash
kubectl get pods
kubectl get svc
```

#### 7. Appliquer la configuration
```bash
kubectl apply -f nginx.yaml
```

#### 8. Expérimenter les mises à jour
Modifier la configuration du pod ou du service et réexécutez : 
```bash
kubectl apply -f nginx.yaml
```

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-04-replicasets.md)

[Revenir à l'atelier precedent](atelier-02-pod.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



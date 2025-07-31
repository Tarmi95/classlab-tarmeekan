
# Atelier 7 : Stockage & Persistent Volume

> 🎯 **Dans cet atelier, nous allons explorer comment les données sont stockées dans un cluster Kubernetes.**  

## PARTIE 1. Utilisation de `EmptyDir` dans Kubernetes

Dans cette partie, nous allons explorer comment utiliser le volume **EmptyDir** dans Kubernetes. L'objectif est de comprendre comment créer un Pod avec un stockage éphémère, monter ce volume dans des conteneurs, et tester son caractère temporaire.


### Etapes à suivre :

#### 1. Créer un dossier de projet `stockage`:

#### 2. Créez un fichier nommé `empty-dir.yaml` et définissez votre pod avec les configurations suivantes :
- Définissez le pod avec `apiVersion: v1` et `kind: Pod`.
- Spécifiez l’image `busybox:1.37`.

#### 3. Définissez le volume `EmptyDir` dans la section `volumes` de votre définition de pod :
```yaml
volumes:
  - name: stockage-temporaire
    emptyDir: {}
```

#### 4. Ajoutez les montages de volume dans la définition de vos conteneurs pour indiquer où le volume EmptyDir doit être monté :
```yaml
volumeMounts:
  - name: stockage-temporaire
    mountPath: /usr/share/temp
```
#### 5. Déployez votre pod en exécutant :
```bash
kubectl apply -f empty-dir.yaml
```
#### 6. Testez si la configuration fonctionne en utilisant `kubectl exec` pour entrer dans le conteneur et créer des fichiers dans le répertoire monté.

#### 7. Vérifiez la persistance des fichiers en supprimant le pod puis en le recréant pour voir si les fichiers montés sont supprimés.

#### 8. Créez un deuxième conteneur dans le même pod, permettant à un conteneur d’écrire et à l’autre de lire depuis le même volume EmptyDir :
- Configurez le conteneur lecteur avec `readOnly: true`.

#### Documentation :

[https://kubernetes.io/docs/concepts/storage/volumes/#emptydir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)

---

## PARTIE 2. Création de volumes persistants et de claims dans Kubernetes

Dans cette partie, nous allons explorer le concept de Persistent Volumes (PV) et de Persistent Volume Claims (PVC) en utilisant un stockage local dans Kubernetes.
L’objectif principal est de comprendre comment créer un volume persistant, définir un claim de volume persistant et les incorporer dans des pods.

### Etapes à suivre :

#### 1. Préparer votre environnement

- Assurez-vous qu’il n’y a aucune ressource dans votre namespace par défaut en vérifiant les pods actuels :
```bash
kubectl get pods
```

#### 2. Créer le Persistent Volume (PV)

- Créez un nouveau fichier YAML nommé `volume-local.yaml`.  
- Spécifiez les paramètres suivants dans la définition du PV :
  - `apiVersion`: `v1`  
  - `kind`: `PersistentVolume`  
  - `metadata`: Donnez un nom à votre volume (`volume-local`).  
  - `spec`: Définir :  
    - `capacity`: mettre à `1Gi`.  
    - `accessModes`: spécifier `ReadWriteOnce`.  
    - `persistentVolumeReclaimPolicy`: mettre à `Retain` ou laisser vide pour la valeur par défaut.  
    - `storageClassName`: mettre à `stockage-local`.  
    - Ajouter l’attribut `local` avec le chemin de montage désiré (assurez-vous que le chemin existe sur le nœud).

#### 3. Appliquer le Persistent Volume

- Appliquez le fichier PV avec la commande :
  ```bash
  kubectl apply -f volume-local.yaml
  ```
- Vérifiez l’état de votre volume :
  ```bash
  kubectl get pv
  ```
- Si des erreurs apparaissent, vérifiez le chemin de montage et corrigez-les.

#### 4. Créer le Persistent Volume Claim (PVC)

- Dans le même répertoire, créez un nouveau fichier YAML nommé `volume-local-claim.yaml`.  
- Spécifiez :
  - `apiVersion`: `v1`  
  - `kind`: `PersistentVolumeClaim`  
  - `metadata`: nommez-le `volume-local-claim`.  
  - `spec`:  
    - `accessModes`: spécifier `ReadWriteOnce`.  
    - `resources`: définissez la requête avec `requests.storage: 1Gi`.  
    - `storageClassName`: mettre à `stockage-local`.

#### 5. Appliquer le Persistent Volume Claim

- Appliquez le fichier PVC :
```bash
kubectl apply -f volume-local-claim.yaml
```
- Confirmez si le PVC est lié en vérifiant :
```bash
kubectl get pvc
```

#### 6. Vérifier le binding

- Si la liaison a réussi, vérifiez les détails du PVC et du PV pour vous assurer qu’ils sont connectés. Utilisez :
```bash
kubectl describe pvc volume-local-claim
```

#### Documentation :

[https://kubernetes.io/docs/concepts/storage/persistent-volumes/](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)


---

## PARTIE 3. Gestion de volumes persistants et de claims dans Kubernetes

Dans cette partie, nous allons explorer les implications de la suppression des Persistent Volume Claims (PVC) et des Persistent Volumes (PV) dans un environnement Kubernetes. 

### Etapes à realiser :

#### 1. Lister vos Pods, PVC et PV actuels.
#### 2. Supprimer les Pods avec la commande appropriée.
#### 3. Supprimer le Persistent Volume Claim.
#### 4. Vérifier le statut du Persistent Volume après la suppression du PVC.
#### 5. Évaluer si les fichiers restent accessibles après la suppression du PV et du PVC.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-8-deploiement_app_bdd.md)

[Revenir à l'atelier precedent](atelier-6-service.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://www.docker.com/)
- [Documentation K3S](https://k3s.io/)



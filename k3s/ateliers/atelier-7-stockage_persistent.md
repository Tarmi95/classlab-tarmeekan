
# Atelier 7 : Stockage & Persistent Volume / Persistent Volume Claim 

> 🎯 **Dans cet atelier, nous allons explorer comment les données sont stockées dans un cluster Kubernetes.**  

### EmptyDir

EmptyDir est un volume éphémère que Kubernetes crée lorsqu’un Pod démarre et qui existe tant que le Pod vit.
Il est vide au départ et peut être utilisé pour partager des données entre plusieurs conteneurs dans le même Pod.

### PersistentVolume (PV)

Un **PersistentVolume** est une ressource dans Kubernetes qui représente un volume de stockage indépendant du cycle de vie des pods. C’est une abstraction du stockage physique (disque local, NFS, cloud volume, etc.) que l’administrateur expose au cluster.

- Il a une capacité (ex. : `1Gi`) et des modes d’accès (ex. : `ReadWriteOnce`).  
- Il peut être **statique** (précréé par l’admin) ou **dynamiquement provisionné** via une `StorageClass`.  
- Il définit aussi une politique de récupération (`persistentVolumeReclaimPolicy`) :
  - `Retain` (conserver les données),  
  - `Recycle` (obsolète),  
  - `Delete` (supprimer la ressource de stockage quand le PVC est supprimé).

### PersistentVolumeClaim (PVC)

Un **PersistentVolumeClaim** est une demande de stockage faite par un utilisateur ou une application. Le PVC spécifie :

- La taille souhaitée (ex. : `1Gi`)  
- Le mode d’accès (ex. : `ReadWriteOnce`, `ReadOnlyMany`, etc.)  
- (optionnel) une `StorageClass`  

Kubernetes fait ensuite le **binding** automatique entre un PVC et un PV compatible (ou crée un PV dynamique si configuré).


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

## PARTIE 4. Provisionnement dynamique de Persistent Volumes dans Kubernetes

Dans cette partie, votre objectif est de mettre en place le provisionnement dynamique de volumes persistants en utilisant la StorageClass **local-path** fournie par défaut par K3S.

## Etapes à suivre :

#### 1. Inspecter la StorageClass `local-path`
  ```bash
  kubectl describe storageclass local-path
  ```
Cela permet de voir la classe de stockage par défaut et ses propriétés, y compris la politique de récupération.

#### 2. Créer un Persistent Volume Claim
- Créez un nouveau fichier nommé `dynamique.yaml`.  
- Copiez un manifest de PVC existante comme exemple, mais modifiez le nom pour quelque chose comme `dynamique-pv`.  
- **Ne spécifiez pas de StorageClass** dans le fichier.

Exemple :
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamique-pv
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

#### 3. Appliquer le PVC
```bash
kubectl apply -f dynamique.yaml
```

#### 4. Vérifier le statut du PVC
```bash
kubectl get pvc
```
Le statut doit s’afficher `Bound`.

#### 5. Décrire le Persistent Volume associé
- Trouvez le nom du volume persistant lié (dans la colonne `VOLUME` de `kubectl get pvc`) et exécutez :
```bash
kubectl describe pv <nom-du-volume>
```
Cela affiche les détails du volume automatiquement provisionné.

#### 6. Tester le processus de suppression
- Supprimez le PVC :
```bash
kubectl delete -f dynamique.yaml
```
- Vérifiez à nouveau les volumes persistants :
```bash
kubectl get pv
```
Confirmez s’il a été supprimé ou s’il reste en fonction de la politique de récupération.


---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-8-deploiement_app_bdd.md)

[Revenir à l'atelier precedent](atelier-6-service.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://www.docker.com/)
- [Documentation K3S](https://k3s.io/)



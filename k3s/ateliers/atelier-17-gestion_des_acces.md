
# Atelier 17 : Gestion des accès 

🎯 **Objectif** : Comprendre et expérimenter la gestion des accès dans Kubernetes à travers les differents mécanismes.

Dans Kubernetes, la gestion des accès permet de contrôler **qui peut faire quoi** dans le cluster. 

-  **CertificateSigningRequest** : objet Kubernetes qui permet de demander un certificat au cluster.

- **ServiceAccount** : Identité attribuée aux pods pour interagir avec l’API Kubernetes.
- **RBAC (Role-Based Access Control)** : Définit et assigne des autorisations aux utilisateurs, groupes ou services.

## PARTIE 1. `CertificateSigningRequest` et `Certificat`

Comprendre et manipuler les **CertificateSigningRequest (CSR)** dans Kubernetes afin de savoir comment un utilisateur peut obtenir un certificat signé pour interagir de manière sécurisée avec le cluster.

#### 1. Générer une paire de clés (privée + publique) pour l'utilisateur nommé `Liam`

Vous pouver générer un certificat manuellement avec [easyrsa](https://github.com/OpenVPN/easy-rsa), [openssl](https://github.com/openssl/openssl) ou [cfssl](https://github.com/cloudflare/cfssl).

- Exécuter dans votre terminal :
```bash
openssl genrsa -out liam.key 4096
openssl req -new -key liam.key -subj "/CN=liam" -out liam.csr
```

> `CN=liam` correspond au nom commun de l’utilisateur.

#### 2. Créer le manifest d'un objet `CertificateSigningRequest` nommé `liam` dans un fichier `csr-liam.yaml`. Encoder le CSR en base64 et supprimer les sauts de ligne :

```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: liam
spec:
  request: $(cat liam.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
```

- Appliquer la configuration :
```bash
kubectl apply -f csr-liam.yaml
```


#### 3. Vérifier le CSR créé
```bash
kubectl get csr
kubectl describe csr liam
```

Le statut de la demande doit être en `Pending`

#### 4. Approuver la requête
- Un administrateur peut approuver la requête :
```bash
kubectl certificate approve liam
```

- A savoir pour la rejeter :
```bash
kubectl certificate deny liam
```

- Vérifier l'approbation ou le rejet
```bash
kubectl get csr
```

#### 5. Récupérer le certificat signé
- Si approuvé, télécharger le certificat signé :
```bash
kubectl get csr liam -o jsonpath='{.status.certificate}' | base64 --decode > liam.crt
```

Vous disposez maintenant :
- de la clé privée `liam.key`
- du certificat signé `liam.crt`

---

## PARTIE 2. `KUBECONFIG`

#### 1. Tester l'accès au cluster via `KUBECONFIG` depuis sa machine avec l'utilisateur `liam`

- Recuperer sur le node controleur `VM2`, le fichier `kubeconfig` localisé à l'emplacement *`/etc/rancher/k3s/k3s.yaml`* contenant toutes les informations nécessaires à `kubectl` et le copier sur *`$HOME/.kube/config`*.

- Adapter le fichier *`$HOME/.kube/config`* afin d'utiliser l'utilisateur `liam`.


- Verifier la configuration kubectl depuis son terminal:

```bash
kubectl cluster-info
```

Sortie attendu : 

```bash
Error from server (Forbidden): services is forbidden: User "liam" cannot list resource "services" in API group "" in the namespace "kube-system"
```

> Cela signifie que votre certificat `liam` est bien authentifié, mais qu’il n’est pas autorisé à lister les services du namespace kube-system.
L'utilisateur `liam` n’a pas les droits `RBAC` nécessaires pour exécuter la commande `kubectl cluster-info`.


- Tester les permissions de lister les pods dans le namespace par défaut :
```bash
# Peut-il lister les pods ? (attendu: no)
kubectl auth can-i list pods --namespace=default --as=liam
```
---

## PARTIE 3. `RBAC (Role-Based Access Control)`

Définit et assigne des autorisations aux utilisateurs, groupes ou services.

- **Role** : permissions limitées à un namespace.  
- **ClusterRole** : permissions globales.  
- **RoleBinding** : attache un rôle à un utilisateur/serviceaccount dans un namespace.  
- **ClusterRoleBinding** : attache un rôle à un utilisateur/serviceaccount dans tout le cluster.  

#### 1. Donner des droits au niveau **namespace** (Role + RoleBinding)

L'utilisateur `liam` est bien authentifié, mais il n’est pas autorisé à lister les services du namespace `kube-system` afin d'exécuter la commande `kubectl cluster-info`.

- Tester les permissions de lister les services dans le namespace `kube-system` en tant que l'utilisateur `liam` :
```bash
# Peut-il lister les services dans le namespace `kube-system` ? (attendu: no)
kubectl auth can-i list svc --namespace=kube-system --as=liam
```

-  Générer le manifest d’un **Role** nommé `role-svc-lecture` sans le créer réellement sur le cluster, qui peut *visualiser les services* (`get`, `list`) dans le namespace `kube-system`. Sauvegarder ce manifest dans un fichier `role-pod-lecture.yaml` :

```bash
# Role (droits limités au namespace kube-system)
kubectl create role role-svc-lecture --verb=get --verb=list --resource=services --namespace=kube-system --dry-run=client -o yaml > role-svc-lecture.yaml
```

- Adapter le manifest `role-svc-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-svc-lecture
  namespace: kube-system
rules:
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - list
```

- Créer le Role :
```bash
kubectl apply -f role-svc-lecture.yaml
```

- Verifications :
```bash
kubectl get role role-svc-lecture -n kube-system
kubectl describe role role-svc-lecture -n kube-system
```

-  Générer le manifest d’un **RoleBinding** nommé `rolebinding-svc-lecture`  sans le créer réellement sur le cluster, pour lier le Role `role-svc-lecture` à l'utlisateur `liam`. Sauvegarder ce manifest dans un fichier `rolebinding-svc-lecture.yaml` :


```bash
kubectl create rolebinding rolebinding-svc-lecture --role=role-svc-lecture --user=liam --namespace=kube-system --dry-run=client -o yaml > rolebinding-svc-lecture.yaml
```

- Adapter le manifest `rolebinding-svc-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rolebinding-svc-lecture
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: role-svc-lecture
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: liam
```

- Créer le RoleBinding :
```bash
kubectl apply -f rolebinding-svc-lecture.yaml
```

- Verifications :
```bash
kubectl get rolebinding rolebinding-svc-lecture -n kube-system
kubectl describe rolebinding rolebinding-svc-lecture -n kube-system
```

- Tester les permissions de lister les services dans le namespace `kube-system` en tant que l'utilisateur `liam` :
```bash
# Peut-il lister les services dans le namespace `kube-system` ? (attendu: yes)
kubectl auth can-i list svc --namespace=kube-system --as=liam
```

- Verifier la configuration kubectl depuis son terminal en tant que l'utilisateur `liam` :

```bash
kubectl cluster-info --as=liam
```

Sortie attendu : 

```bash
Kubernetes control plane is running at https://192.168.56.12:6443
CoreDNS is running at https://192.168.56.12:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://192.168.56.12:6443/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

```

- Lister tous les nœuds membres du cluster Kubernetes depuis sa machine en tant que `liam`:

```bash
kubectl get nodes --as=liam
```

Sortie attendu : 

```bash
Error from server (Forbidden): nodes is forbidden: User "liam" cannot list resource "nodes" in API group "" at the cluster scope
```

> Cela signifie que l'utilisateur `liam` n’a pas les droits `RBAC` nécessaires pour exécuter la commande `kubectl get nodes`.


#### 2. Donner des droits globaux au **cluster** (ClusterRole + ClusterRoleBinding)


L'utilisateur `liam` est bien authentifié, mais il n’est pas autorisé à lister tous les nœuds membres du cluster Kubernetes.

-  Générer le manifest d’un **ClusterRole** nommé `clusterrole-node-lecture` sans le créer réellement sur le cluster, qui peut *visualiser les nodes* (`get`, `list`). Sauvegarder ce manifest dans un fichier `clusterrole-node-lecture.yaml` :

```bash
# ClusterRole (droits globaux au cluster)
kubectl create clusterrole clusterrole-node-lecture --verb=get --verb=list --resource=nodes --dry-run=client -o yaml > clusterrole-node-lecture.yaml
```

- Adapter le manifest `clusterrole-node-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: clusterrole-node-lecture
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
```

- Créer le ClusterRole :
```bash
kubectl apply -f clusterrole-node-lecture.yaml
```

- Verifications :
```bash
kubectl get clusterrole clusterrole-node-lecture
kubectl describe clusterrole clusterrole-node-lecture
```

-  Générer le manifest d’un **ClusterRoleBinding** nommé `clusterrolebinding-node-lecture` sans le créer réellement sur le cluster, pour lier le ClusterRole `clusterrole-node-lecture` à l'utlisateur `liam`. Sauvegarder ce manifest dans un fichier `clusterrolebinding-node-lecture.yaml` :

```bash
kubectl create clusterrolebinding clusterrolebinding-node-lecture --clusterrole=clusterrole-node-lecture --user=liam --dry-run=client -o yaml > clusterrolebinding-node-lecture.yaml
```

- Adapter le manifest `clusterrolebinding-node-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: clusterrolebinding-node-lecture
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: clusterrole-node-lecture
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: liam
```

- Créer le ClusterRoleBinding :
```bash
kubectl apply -f clusterrolebinding-node-lecture.yaml
```

- Vérifier les objets :
```bash
kubectl get clusterrolebinding clusterrolebinding-node-lecture
kubectl describe clusterrolebinding clusterrolebinding-node-lecture
```

- Tester les permissions :
```bash
# Peut-il lister les nodes ? (attendu: yes)
kubectl auth can-i list nodes --as=liam
```

- Lister tous les nœuds membres du cluster Kubernetes depuis sa machine en tant que `liam`:

```bash
kubectl get nodes --as=liam
```

Sortie attendu : 

```bash
NAME   STATUS   ROLES                  AGE   VERSION
vm2    Ready    control-plane,master   31m   v1.32.3+k3s1
vm3    Ready    <none>                 30m   v1.32.3+k3s1
```

---

## PARTIE 4. Créer et utiliser un `ServiceAccount` avec `RBAC`

- **ServiceAccount** : Identité attribuée aux pods pour interagir avec l’API Kubernetes.
- **RBAC (Role-Based Access Control)** : Définit et assigne des autorisations aux utilisateurs, groupes ou services.

#### 1. Création d'un Namespace nommé `access`
```bash
kubectl create namespace access
```

#### 2. Définir `access` comme namespace par défaut 
```bash
kubectl config set-context --current --namespace=access
```

#### 3. Vérification d'un Namespace nommé `access`
```bash
kubectl get namespace access
```

#### 4. Création d'un ServiceAccount nommé `access-sa`
```bash
kubectl create sa access-sa
```

> Le ServiceAccount `access-sa` servira d’identité pour un pod ou une application.

#### 5. Vérification d'un ServiceAccount nommé `access-sa`
```bash
kubectl get sa access-sa
```

#### 6. Donner des droits **namespace** (Role + RoleBinding)

-  Générer le manifest d’un **Role** nommé `pod-lecture` qui peut *visualiser les Pods* (`get`, `list`) dans le namespace courant `access`, puis l’attacher au ServiceAccount `access-sa` sans le créer réellement sur le cluster, et de sauvegarder ce manifest dans un fichier `role-pod-lecture.yaml` :

```bash
# Role (droits limités au namespace courant)
kubectl create role role-pod-lecture --verb=get --verb=list --resource=pods --dry-run=client -o yaml > role-pod-lecture.yaml
```

- Adapter le manifest `role-pod-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-pod-lecture
  namespace: access
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
```

- Créer le Role :
```bash
kubectl apply -f role-pod-lecture.yaml
```

- Verifications :
```bash
kubectl get role role-pod-lecture
kubectl describe role role-pod-lecture
```

-  Générer le manifest d’un **RoleBinding** nommé `rolebinding-pod-lecture` pour lier le Role `role-pod-lecture` au ServiceAccount `access-sa` sans le créer réellement sur le cluster, et de sauvegarder ce manifest dans un fichier `rolebinding-pod-lecture.yaml` :

```bash
kubectl create rolebinding rolebinding-pod-lecture --role=role-pod-lecture --serviceaccount=access:access-sa --dry-run=client -o yaml > rolebinding-pod-lecture.yaml
```

- Adapter le manifest `rolebinding-pod-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rolebinding-pod-lecture
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: role-pod-lecture
subjects:
- kind: ServiceAccount
  name: access-sa
  namespace: access
```

- Créer le RoleBinding :
```bash
kubectl apply -f rolebinding-pod-lecture.yaml
```

- Verifications :
```bash
kubectl get rolebinding rolebinding-pod-lecture
kubectl describe rolebinding rolebinding-pod-lecture
```

#### 7. Tester les permissions **sans** créer de pod :
```bash
# Peut-il lister les pods dans access ? (attendu: yes)
kubectl auth can-i list pods --as=system:serviceaccount:access:access-sa --namespace=access

# Peut-il créer des services ? (attendu: no)
kubectl auth can-i create services --as=system:serviceaccount:access:access-sa --namespace=access
```

#### 8. Donner des droits globaux au **cluster** (ClusterRole + ClusterRoleBinding)

-  Générer le manifest d’un **ClusterRole** nommé `clusterrole-node-lecture` qui peut *visualiser les Nodes* sans le créer réellement sur le cluster, et de sauvegarder ce manifest dans un fichier `clusterrole-node-lecture.yaml` :

```bash
# ClusterRole (droits globaux au cluster)
kubectl create clusterrole clusterrole-node-lecture --verb=get --verb=list --resource=nodes --dry-run=client -o yaml > clusterrole-node-lecture.yaml
```

- Adapter le manifest `clusterrole-node-lecture.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: clusterrole-node-lecture
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
```

- Créer le ClusterRole :
```bash
kubectl apply -f clusterrole-node-lecture.yaml
```


-  Générer le manifest d’un **ClusterRoleBinding** nommé `clusterrolebinding-node-lecture-sa` pour lier le ClusterRole `clusterrole-node-lecture` au ServiceAccount `access-sa` (au niveau cluster) sans le créer réellement sur le cluster, et de sauvegarder ce manifest dans un fichier `clusterrolebinding-node-lecture-sa.yaml` :

```bash
kubectl create clusterrolebinding clusterrolebinding-node-lecture-sa --clusterrole=clusterrole-node-lecture --serviceaccount=access:access-sa --dry-run=client -o yaml > clusterrolebinding-node-lecture-sa.yaml
```

- Adapter le manifest `clusterrolebinding-node-lecture-sa.yaml` comme ci-dessous  :
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: clusterrolebinding-node-lecture-sa
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: clusterrole-node-lecture
subjects:
- kind: ServiceAccount
  name: access-sa
  namespace: access
```

- Créer le ClusterRoleBinding :
```bash
kubectl apply -f clusterrolebinding-node-lecture-sa.yaml
```

- Vérifier les objets :
```bash
kubectl get clusterrole clusterrole-node-lecture
kubectl describe clusterrole clusterrole-node-lecture
kubectl get clusterrolebinding clusterrolebinding-node-lecture-sa
kubectl describe clusterrolebinding clusterrolebinding-node-lecture-sa
```

#### 9. Tester les permissions :
```bash
# Peut-il lister les nodes ? (attendu: yes)
kubectl auth can-i list nodes --as=system:serviceaccount:access:access-sa
```

#### 10. Vérification depuis kubernetes-dashboard 
Pour des tests d’API directs, générer un token court-terme :

- Générer un token d'accès :

```bash
kubectl create token access-sa
```

- Accéder et se connecter au kubernetes Dashboard

Ouvrir votre navigateur et aller à :

**[https://192.168.56.241/#/login](https://192.168.56.241/#/login)**

Sur la page d’accueil du Dashboard, sélectionner “Jeton”.


Ignorer l’avertissement de certificat auto‑signé (Accepter le risque).


Coller le token access-sa généré précédemment.


Connexion (Valider) : tu arrives alors sur l’interface graphique du Kubernetes Dashboard.


#### 11. Attribuer des droits cluster-admin

```bash
kubectl create clusterrolebinding clusterrolebinding-admin-sa \
  --serviceaccount=access:access-sa \
  --clusterrole=cluster-admin
```

- Verifiez que vous disposez des droits administrateur dans le cluster depuis kubernetes Dashboard


#### 12. Nettoyage

Penser à supprimer les ressources.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-18-autoscaling.md)

[Revenir à l'atelier precedent](atelier-16-nodeselector_affinity_taints.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



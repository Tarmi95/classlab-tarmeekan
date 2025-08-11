
# Atelier 11 : Secret

> 🎯 Dans cet atelier, vous devez créer, gérer et utiliser des **Secrets** dans Kubernetes afin de sécuriser les informations sensibles (mots de passe, clés API, certificats, etc.) dans vos applications.

À l’issue de cet atelier, vous devez être capable de :

- Créer un `Secret` de type `Opaque`
- Vérifier que le Secret a bien été créé dans le cluster
- Déployer un Pod qui utilise ce Secret comme variables d’environnement.
- Créer un deuxième Pod qui utilise le même Secret, mais monté comme volume.
- Lister et observer les fichiers générés dans le volume.



## PARTIE 1. Création d’un `Secret` avec l'approche imperative  

#### 1. Création d’un Secret
```bash
kubectl create secret generic mon-secret --from-literal=username=admin --from-literal=password=MonMotDePasse123
```

#### 2. Vérification du Secret
```bash
kubectl get secrets
kubectl describe secret mon-secret
```
---

## PARTIE 2. Utilisation du `Secret` comme variables d’environnement

#### 1. Créer le fichier `pod-secret-env.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret-env
spec:
  containers:
  - name: app
    image: nginx:1.28.0
    env:
    - name: USERNAME
      valueFrom:
        secretKeyRef:
          name: mon-secret
          key: username
    - name: PASSWORD
      valueFrom:
        secretKeyRef:
          name: mon-secret
          key: password
```

#### 2. Déployez :
```bash
kubectl apply -f pod-secret-env.yaml
```

#### 3. Afficher les variables d’environnement du conteneur :
```bash
kubectl exec -it pod-secret-env -- sh -c "env | grep -E 'USERNAME|PASSWORD'"
```

---

## PARTIE 3. Utilisation du `Secret` comme volume

#### 1. Créer le fichier `pod-secret-volume.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret-volume
spec:
  containers:
    - name: app
      image: nginx:1.28.0
      volumeMounts:
        - name: secret-volume
          mountPath: /etc/secret-volume
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: mon-secret
```

#### 2. Déployez :
```bash
kubectl apply -f pod-secret-volume.yaml
```

#### 3. Effectuez les Vérifications 
- Se connecter dans le conteneur du pod et lancer shell :

```bash
kubectl exec -it pod-secret-volume -- sh
```

- Les données sont exposées au conteneur via un volume monté sous `/etc/secret-volume` :

```bash
ls /etc/secret-volume
cat /etc/secret-volume/username
cat /etc/secret-volume/password
```

---

### 💡 A savoir

- Les **Secrets** doivent toujours être utilisés pour stocker des informations sensibles.
- Évitez de les stocker en clair dans les manifests YAML (utilisez `kubectl create secret` ou des outils comme `SealedSecrets` etc...).
- Un Secret peut être injecté dans un Pod :
  - Sous forme de **variables d’environnement**
  - Monté comme **volume**
- Par défaut, les Secrets sont encodés en **base64** dans etcd (pas chiffrés). 


---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-11-secret.md)

[Revenir à l'atelier precedent](atelier-9-ingress.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)




# Atelier 10 : ConfigMap

> 🎯 Dans cet atelier, vous devez externaliser la configuration d’une application dans Kubernetes en utilisant un **ConfigMap**, puis l’injecter dans un Pod de deux manières différentes :
- En tant que **variables d’environnement**.
- En tant que **fichiers montés dans un volume**.


Ensuite, vous mettrez à jour le ConfigMap pour observer l’impact sur le Pod.


À l’issue de cet atelier, vous devez être capable de :

- Créer un ConfigMap à partir de différentes sources.
- Injecter les données du ConfigMap dans un Pod sous forme de variables d’environnement et de fichiers montés.
- Mettre à jour un ConfigMap et constater son effet sur les ressources qui l’utilisent.



## PARTIE 1. Création d’un `ConfigMap` avec l'approche imperative  

#### 1. Création d’un ConfigMap
```bash
kubectl create configmap app-config --from-literal=APP_COLOR=bleu --from-literal=APP_MODE=prod
```

#### 2. Verification du contenu
```bash
kubectl get configmap app-config -o yaml
```
ou
```bash
kubectl describe configmap app-config 
```
---

## PARTIE 2. Création d’un Pod utilisant le `ConfigMap` comme variables d’environnement

#### 1. Créer le fichier `pod-env.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-env
spec:
  containers:
  - name: app
    image: busybox:1.37.0
    command: ["sh", "-c", "env; sleep 3600"]
    envFrom:
    - configMapRef:
        name: app-config
```

#### 2. Déployez :
```bash
kubectl apply -f pod-env.yaml
```

#### 3. Vérifiez :
```bash
kubectl exec -it pod-env -- env | grep APP_
```

---

## PARTIE 3. Création d’un Pod montant le `ConfigMap` dans un volume

#### 1. Créer le fichier `pod-volume.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-volume
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "cat /config/APP_COLOR; sleep 3600"]
    volumeMounts:
    - name: config-volume
      mountPath: /config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

#### 2. Déployez :
```bash
kubectl apply -f pod-volume.yaml
```

#### 3. Vérifiez :
```bash
kubectl exec -it pod-volume -- ls /config
```

---

## PARTIE 4. Mise à jour du ConfigMap

#### 1. Mettre à jour le `ConfigMap` :

```bash
kubectl create configmap app-config   --from-literal=APP_COLOR=rouge    --from-literal=APP_MODE=dev  -o yaml --dry-run=client | kubectl apply -f -
```

#### 2. Vérifiez à nouveau dans le Pod (attention, il faut parfois le redémarrer pour voir les nouvelles valeurs) :
```bash
kubectl exec -it pod-env -- env | grep APP_
```

---

### 💡 A savoir

- Les ConfigMaps permettent de séparer la configuration du code.
- Ils peuvent être injectés comme variables d’environnement ou montés comme fichiers.
- Une mise à jour n’impacte pas toujours automatiquement les Pods (sauf si une configuration de redéploiement est prévue).


---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-11-secret.md)

[Revenir à l'atelier precedent](atelier-9-ingress.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



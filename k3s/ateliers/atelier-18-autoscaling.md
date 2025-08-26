
# Atelier 18 : Autoscaling

> 🎯 Dans cet atelier, vous allez apprendre à **mettre à l'echelle manuellement ou automatiquement** dans un cluster Kubernetes afin de répondre à une charge variable.  



## PARTIE 1. Le Scaling manuel

Le scaling manuel s’applique avec `kubectl scale` ou en modifiant directement le champ `replicas` dans le manifest YAML. 

- Le **scaling manuel** est utile pour tester ou réagir ponctuellement à une charge.  
- L’administrateur choisit **explicitement** le nombre de Pods.  
- Kubernetes ne prend **aucune décision automatique** dans ce mode.

#### 1. Création d’un Deployment avec le manifest `deployment-nginx.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
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

#### 2. Déployer l’application :
```bash
kubectl apply -f deployment-nginx.yaml
```

#### 3. Vérifier le déploiement :
```bash
kubectl get deployments
kubectl get pods
```

#### 4. Augmenter le nombre de Pods à 3 en utilisant le Scaling manuel avec `kubectl scale`

```bash
kubectl scale deployment nginx-deployment --replicas=3
```

#### 5. Vérifier l’état du déploiement :
```bash
kubectl get deployments
kubectl get pods -o wide
```

Observez que 3 Pods sont désormais en cours d’exécution.

#### 6. Réduire le nombre de Pods à 1 :
```bash
kubectl scale deployment nginx-deployment --replicas=1
```

#### 7. Vérifier à nouveau :
```bash
kubectl get deployments
kubectl get pods
```

Un seul Pod doit rester en cours d’exécution.

---

## PARTIE 2. Horizontal Pod Autoscaler (HPA)

Dans cette partie, vous allez découvrir comment Kubernetes ajuste automatiquement le nombre de Pods en fonction de l’utilisation des ressources.  

#### 1. Déployer l’application Astreinte :

- Creer un fichier `astreinte-app.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: astreinte-app
  labels:
    app: astreinte-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: astreinte-app
  template:
    metadata:
      labels:
        app: astreinte-app
    spec:
      containers:
      - name: astreinte-app
        image: ftutorials/python-app
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: astreinte-app-svc
  labels:
    app: astreinte-app
spec:
  selector:
    app: astreinte-app
  ports:
  - name: http
    protocol: TCP
    port: 80     
    targetPort: 5000
    nodePort: 30081    
  type: NodePort   
```

- Appliquer :

```bash
kubectl apply -f astreinte-app.yaml
```


#### 2. Vérifier :
```bash
kubectl get deploy,pods,svc -l app=astreinte-app -o wide
```

#### 3. Créer un HPA qui surveille le déploiement et ajuste le nombre de Pods entre 1 à 5 pour maintenir l’utilisation CPU moyenne autour de 50 %.  :


```bash
kubectl autoscale deployment astreinte-app --cpu-percent=50 --min=1 --max=5
```


#### 4. Vérifier :
```bash
kubectl get hpa
```

Sortie attendu :

```bash
NAME            REFERENCE                  TARGETS               MINPODS   MAXPODS   REPLICAS    AGE
astreinte-app   Deployment/astreinte-app   cpu: <unknown>/50%     1         5         1          10s
```

La colonne TARGETS du HPA indique **cpu: <utilisation_actuelle>% / <seuil_HPA>%**

Lorsque `cpu: <unknown>/50%` cela veut dire que le HPA n’arrive pas à obtenir la métrique CPU actuelle pour l'un des causes ci-dessous :
- Pas encore assez de mesures
- metrics-server manquant ou KO
- Requests CPU absents

Pour avoir plus d'info :
```bash
kubectl describe hpa astreinte-app
```



#### 5. Générer de la charge et observer

- Lancer le script `hpa-generateur-charge.sh` qui va générer une charge et qu’il doit tourner jusqu’à la fin : 

```bash
/vagrant/k3s/scripts/hpa-generateur-charge.sh
```

- Dans un autre terminal, observer :
```bash
kubectl get hpa -w
kubectl get pods -l app=astreinte-app -w
```

Vous devriez voir le nombre de Pods augmenter (jusqu’à 5) quand la charge est élevée, puis redescendre à 1 une fois la charge arrêtée.

```
      Utilisation CPU
         ▲
 200% ───│■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ surcharge
 150% ───│■■■■■■■■■■■■■■■■■■■■■
 100% ───│■■■■■■■■■■■■
  50% ───│■■■■    ← Seuil HPA
   0% ───┴─────────────────────────▶ Temps
         1 pod                   5 pods
```


---

## PARTIE 4. Nettoyage
```bash
kubectl delete hpa astreinte-app
kubectl delete -f astreinte-app.yaml
kubectl delete pod test --force=true
```

---

### 💡 A savoir
- L’HPA se base sur les métriques CPU/mémoire → nécessite **metrics-server**.  
- Vous pouvez aussi l’étendre avec des métriques personnalisées (latence, requêtes HTTP/s…).  
- L’HPA ajuste uniquement le **nombre de Pods** (pas leurs ressources).  

---

## PARTIE 3. Vertical Pod Autoscaler (VPA)

Dans cette partie, vous allez découvrir comment Kubernetes peut **ajuster automatiquement les ressources (CPU et mémoire) demandées par vos Pods** grâce au VPA. 

#### 1. Déployer l’application Astreinte :

- Creer un fichier `astreinte-app.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: astreinte-app
  labels:
    app: astreinte-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: astreinte-app
  template:
    metadata:
      labels:
        app: astreinte-app
    spec:
      containers:
      - name: astreinte-app
        image: ftutorials/python-app
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: astreinte-app-svc
  labels:
    app: astreinte-app
spec:
  selector:
    app: astreinte-app
  ports:
  - name: http
    protocol: TCP
    port: 80     
    targetPort: 5000
    nodePort: 30081    
  type: NodePort  
```

- Appliquer :

```bash
kubectl apply -f astreinte-app.yaml
```

#### 2. Vérifier :
```bash
kubectl get deploy astreinte-app
kubectl get pods -l app=astreinte-app
```

---

#### 3. Installer VPA

Le [VPA](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) n’est pas installé par défaut.  


```bash
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler
./hack/vpa-up.sh
```

#### 4. Vérifier :
```bash
kubectl get pods -n kube-system | grep vpa
```

Sortie attendu :

```bash
vpa-admission-controller-5d79d9f956-wvmfx   1/1     Running     0               28s
vpa-recommender-544df95d65-kj6wg            1/1     Running     0               31s
vpa-updater-54ddf66b6d-nktk8                1/1     Running     0               31s
```


#### 5. Créer un fichier `astreinte-app-vpa.yaml` :

```yaml
apiVersion: "autoscaling.k8s.io/v1"
kind: VerticalPodAutoscaler
metadata:
  name: astreinte-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: astreinte-app
  updatePolicy:
    updateMode: "Off" 
  resourcePolicy:
    containerPolicies:
      - containerName: '*'
        minAllowed:
          cpu: 100m
        maxAllowed:
          cpu: 1000m
        controlledResources: ["cpu"]
```

#### 6. Appliquer le VPA :
```bash
kubectl apply -f astreinte-app-vpa.yaml
```

#### 7. Vérifier les recommandations :
```bash
kubectl describe vpa astreinte-app-vpa
```

Vous devriez voir apparaître une section **Recommendations** avec des valeurs ajustées de `cpu` et `memory`.


#### 8. Modifier `astreinte-app-vpa.yaml` pour activer le mode Auto :
```yaml
updatePolicy:
  updateMode: "Auto"
```

#### 9. Ré-appliquer :
```bash
kubectl apply -f astreinte-app-vpa.yaml
```

#### 10. Générer de la charge et observer

- Lancer le script `vpa-generateur-charge.sh` qui va générer une charge et qu’il doit tourner jusqu’à la fin : 

```bash
/vagrant/k3s/scripts/vpa-generateur-charge.sh
```

- Dans un autre terminal, observer :
```bash
kubectl get vpa -w
kubectl get pods -l app=astreinte-app -w
```

Les Pods seront redémarrés et leurs `requests/limits` mis à jour automatiquement.


#### 11. Nettoyage
```bash
kubectl delete vpa astreinte-app-vpa
kubectl delete -f astreinte-app-vpa.yaml
```

### 💡 A savoir
- Le VPA ajuste **les ressources des Pods**, contrairement à l’HPA qui ajuste **le nombre de Pods**.  
- Il existe quatre modes :  
  - `Off` : seulement des recommandations, aucun changement  
  - `Initial` : applique seulement lors de la création des Pods.  
  - `Auto` : applique automatiquement (redémarre les Pods si nécessaire). 
  - `Recreate` : similaire à "Auto" avec un redémarrage des Pods manuellement.   

---

### Atelier terminé ! Félicitations !!!

[Passer à l'atelier suivant](atelier-18-autoscaling.md)

[Revenir à l'atelier precedent](atelier-17-gestion_des_acces.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



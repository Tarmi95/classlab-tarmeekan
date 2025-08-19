
# Atelier 15 : Labels et Selectors

> 🎯 À la fin de cet atelier, vous serez capables de :
- Créer et appliquer des **labels** sur des objets Kubernetes (pods, services, etc.).
- Utiliser les **selectors** pour cibler des ressources spécifiques.
- Comprendre le lien entre **labels** et **services** pour l'exposition des applications.


Vous allez créer deux applications simples (nginx et httpd), leur attribuer des labels, puis utiliser un **Service** avec un selector pour rediriger le trafic vers l’une ou l’autre en fonction des labels appliqués.


## PARTIE 1. Découvrir `Labels et Selectors`

#### 1. Créer un namespace nommé `labels-selectors` 
```bash
kubectl create namespace labels-selectors
```

#### 2. Définir `labels-selectors` comme namespace par défaut 
```bash
kubectl config set-context --current --namespace=labels-selectors
```

---

#### 3. Créer deux Deployments avec des `Labels` distincts
Créez un fichier `deploy-nginx-httpd.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  labels:
    app: web
    tier: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:1.28.0
        ports:
        - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deploy
  labels:
    app: web
    tier: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: httpd
  template:
    metadata:
      labels:
        app: httpd
        tier: backend
    spec:
      containers:
      - name: httpd
        image: httpd:2.4.65
        ports:
        - containerPort: 80
```

Appliquez le fichier :
```bash
kubectl apply -f deploy-nginx-httpd.yaml
```


#### 4. Vérifier les pods et leurs `Labels`
```bash
kubectl get pods --show-labels
```

---

#### 5. Créer un Service basé sur un `Selector`
Créez un fichier `service-selector.yaml` :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: nginx   # Service enverra le trafic uniquement aux pods ayant ce label
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```

Appliquez :
```bash
kubectl apply -f service-selector.yaml
```

---

#### 6. Tester le Service
- Récupérez un pod :

```bash
kubectl get pods -l app=nginx
```

- Tester la connectivité via `curl` ou le navigateur `web` :

```bash
kubectl exec -it <nginx-pod-name> -- curl web-service
```

```bash
http://<EXTERNAL-IP>
```

---

#### 7.  Modifier le `Selector` pour cibler httpd
Éditez `service-selector.yaml` et changez :
```yaml
selector:
  app: httpd
```

Ré-appliquez :
```bash
kubectl apply -f service-selector.yaml
```

Testez à nouveau avec `curl` : cette fois le trafic doit être redirigé vers les pods `httpd`.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-16-nodeselector_affinity_taints)

[Revenir à l'atelier precedent](atelier-14-namespace.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)





# Atelier 14 : Namespaces, ResourceQuota et LimitRange

> 🎯 Dans cet atelier, vous devez créer et utiliser des **Namespaces**, appliquer des **ResourceQuota** et des **LimitRange** afin de mieux organiser et contrôler l’utilisation des ressources dans votre cluster Kubernetes.

À l’issue de cet atelier, vous devez être capable de :

- Créer et utiliser un **Namespace**
- Déployer des objets dans un Namespace donné
- Appliquer un **ResourceQuota** pour limiter les ressources consommées dans un Namespace
- Appliquer un **LimitRange** pour définir des valeurs par défaut et des bornes de requests/limits

---

## PARTIE 1. Création d’un Namespace

#### 1. Création d'un Namespace nommé `ecole`
```bash
kubectl create namespace ecole
```

#### 2. Vérification de la création
```bash
kubectl get namespaces
```

---

## PARTIE 2. Déploiement dans un Namespace

#### 1. Déploiement `nginx-deploy` dans le Namespace `ecole`
- Créez un fichier `nginx-deploy.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: ecole
spec:
  replicas: 2
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

- Appliquez :
```bash
kubectl apply -f nginx-deploy.yaml
```

- Vérifiez :
```bash
kubectl get pods -n ecole
```

---

## PARTIE 3. Application d’un ResourceQuota

#### 1. Verifier la présence ou non de `ResourceQuota` dans le Namespace `ecole`
```bash
kubectl get quota -n ecole
```

#### 2. Créer le fichier `resource-quota.yaml`

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota-demo
  namespace: ecole
spec:
  hard:
    pods: "3"                   # max 3 Pods
    requests.cpu: "300m"         # max 0.3 CPU réservé
    requests.memory: "300Mi"     # max 300Mi de mémoire réservée
    limits.cpu: "600m"           # max 0.6 CPU limite
    limits.memory: "600Mi"       # max 600Mi de mémoire limite
```

- Appliquez :
```bash
kubectl apply -f resource-quota.yaml
```

#### 2. Vérifiez
```bash
kubectl describe quota quota-demo -n ecole
```

#### 3. Dans `nginx-deploy.yaml` augmenter le nombre de replicas à 5, appliquez et observez.

---

## PARTIE 4. Application d’un LimitRange

#### 1. Créer le fichier `limit-range.yaml`

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: defaults
  namespace: ecole
spec:
  limits:
  - type: Container
    defaultRequest:
      cpu: "100m"      # valeur minimale réservée par défaut
      memory: "100Mi"  # mémoire minimale réservée par défaut
    default:
      cpu: "200m"      # valeur limite par défaut
      memory: "200Mi"
    max:
      cpu: "500m"
      memory: "400Mi"
    min:
      cpu: "50m"
      memory: "64Mi"
```

- Appliquez :
```bash
kubectl apply -f limit-range.yaml
```

#### 2. Vérifiez
```bash
kubectl describe limitrange defaults -n ecole
```

---

### 💡 A savoir

- Les **Namespaces** permettent d’isoler les ressources et faciliter l’organisation.
- Les **ResourceQuotas** limitent la consommation totale des ressources dans un Namespace.
- Les **LimitRanges** imposent des valeurs minimales, maximales et par défaut pour les containers.

---

### Atelier terminé ! Félicitations !!!

[Passer à l'atelier suivant](atelier-15-labels_selectors.md)

[Revenir à l'atelier precedent](atelier-13-limitation_des_ressources.md)

[Retour à la page démarrer avec kubernetes](../README.md)

---

## 📚 Pour aller plus loin

- [Namespaces Kubernetes](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [ResourceQuota Kubernetes](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [LimitRange Kubernetes](https://kubernetes.io/docs/concepts/policy/limit-range/)


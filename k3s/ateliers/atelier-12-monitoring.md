
# Atelier 12 : Monitoring dans kubernetes

> 🎯 Dans cet atelier, nous allons explorer comment surveiller l’état du cluster, des applications, et des ressources afin de **détecter les problèmes en temps réel**.

**Pourquoi c’est important ?**
- Détecter les erreurs avant qu’elles n’impactent les utilisateurs.
- Suivre l’utilisation des ressources (CPU, mémoire, etc.).
- Comprendre le comportement des applications dans le cluster.
- Faciliter le debug et l’optimisation.


## PARTIE 1. `kubectl top`

`kubectl top` est une commande de `kubectl` affichant des métriques live sur l’usage CPU et mémoire des pods et noeuds. Contrairement à kubectl get, elle aide à surveiller l'état du cluster en temps réel.


Vous aurez besoin du `Metrics Server` pour que `kubectl top` fonctionne.


#### 1. Vérification si `Metrics Server` est en cours d'execution
```bash
kubectl get deployment metrics-server -n kube-system
```

- Installer `Metrics Server` si manquant
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

#### 2. Tester `kubectl top`

- Usage nœuds :
```bash
kubectl top nodes
```

- Usage pods (namespace courant) :
```bash
kubectl top pods
```

- Tous les namespaces :
```bash
kubectl top pods --all-namespaces
```

- Trier par CPU ou mémoire :
```bash
kubectl top pods --sort-by=cpu
kubectl top pods --sort-by=memory
```

#### 3. Surveillance en temps réel

- Affichage actualisé toutes les 5s des pods : :
```bash
watch -n 5 kubectl top pods --all-namespaces
```

- Affichage actualisé toutes les 5s des nodes : :
```bash
watch -n 5 kubectl top nodes
```

---

## PARTIE 2. Mettre en place un système de monitoring en utilisant `Prometheus + Grafana `

- **Prometheus** : collecte et stocke les métriques du cluster.
- **Grafana** : visualise les données de Prometheus sous forme de dashboards.


#### 1. Créer le namespace `monitoring`
```bash
kubectl create namespace monitoring
```

#### 2. Ajouter le repo Helm de `prometheus`
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

#### 3. Installer `prometheus` dans le namespace `monitoring`
```bash
helm install prometheus prometheus-community/prometheus --version 27.30.0 --namespace monitoring
```

#### 4. Vérifier le déploiement et les services exposés
```bash
kubectl get pods,svc -n monitoring
```

#### 5. Exposer `prometheus-server` à l'exterieur du cluster
```bash
kubectl patch svc prometheus-server \
  -n monitoring \
  -p '{"spec": {"type": "NodePort"}}'
```

### 6. Accéder à `prometheus`
Ouvrir votre navigateur et aller sur :
```bash
http://IP-NODE:PORT
```

#### 7. Ajouter le repo Helm de `grafana`
```bash
helm repo add grafana https://grafana.github.io/helm-charts
```

#### 8. Installer `grafana` dans le namespace `monitoring`
```bash
helm install grafana grafana/grafana --version 9.3.2 --namespace monitoring
```

#### 9. Vérifier le déploiement et les services exposés
```bash
kubectl get pods,svc -n monitoring
```

#### 10. Exposer `grafana` à l'exterieur du cluster
```bash
kubectl patch svc grafana \
  -n monitoring \
  -p '{"spec": {"type": "NodePort"}}'
```

### 11. Accéder et se connecter à `grafana`
- Ouvrir votre navigateur et aller sur :
```bash
http://IP-NODE:PORT
```

- Obtenir les identifiants par défaut :
```bash
kubectl get secret grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 -d; echo
kubectl get secret grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d; echo
```

### 12. Explorer `grafana`
- Dans `grafana`, connecter `prometheus` comme data source.
- Installer [K8S Dashboard](https://grafana.com/grafana/dashboards/15661-k8s-dashboard-en-20250125/) dans `grafana`
- Ouvrez le dashboard `K8S Dashboard` et observez la consommation CPU et mémoire.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-13-limitation_des_ressources.md)

[Revenir à l'atelier precedent](atelier-11-secret.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Site officiel Grafana](https://grafana.com/)
- [Site officiel Prometheus](https://prometheus.io/)
- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



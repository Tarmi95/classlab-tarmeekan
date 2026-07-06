# Débuter avec Prometheus + Grafana dans K3s

[Prometheus](https://prometheus.io/) est un système de collecte de métriques open source. [Grafana](https://grafana.com/) est une plateforme de visualisation qui transforme ces métriques en dashboards interactifs.

---

## 🎯 Objectifs

- Comprendre l'architecture de monitoring Prometheus + Grafana.
- Installer Prometheus et Grafana dans un cluster K3s via Helm.
- Connecter Grafana à Prometheus comme source de données.
- Explorer les métriques du cluster et créer un dashboard.

---

## Architecture

```
Cluster K3s
┌─────────────────────────────────────────────────┐
│                                                 │
│  ┌──────────────┐     scrape (pull)             │
│  │  kube-state  │ ◄──────────────────┐          │
│  │   -metrics   │                    │          │
│  └──────────────┘                    │          │
│                                      │          │
│  ┌──────────────┐     scrape (pull)  │          │
│  │ node-exporter│ ◄──────────────────┤          │
│  └──────────────┘                    │          │
│                                ┌─────┴──────┐   │
│                                │ Prometheus │   │
│                                │  (stockage │   │
│                                │  métriques)│   │
│                                └─────┬──────┘   │
│                                      │ PromQL   │
│                                ┌─────▼──────┐   │
│                                │  Grafana   │   │
│                                │ (dashboards│   │
│                                │  alertes)  │   │
│                                └────────────┘   │
└─────────────────────────────────────────────────┘
```

Prometheus fonctionne en mode **pull** : c'est lui qui va chercher les métriques auprès des exporters à intervalles réguliers (scrape). Grafana interroge ensuite Prometheus via le langage **PromQL** pour afficher les données.

---

## Prérequis

- Cluster K3s opérationnel (VM2 + VM3)
- `kubectl` et `helm` configurés sur VM1
- Accès réseau aux NodePorts depuis ta machine

Vérifie que Helm est disponible :

```bash
helm version
kubectl get nodes
```

---

## PARTIE 1 — Installer Prometheus

### 1 Crée le namespace `monitoring`

```bash
kubectl create namespace monitoring
```

### 2 Ajoute le repo Helm de la communauté Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 3 Installe le chart `prometheus` dans le namespace `monitoring`

```bash
helm install prometheus prometheus-community/prometheus \
  --version 27.30.0 \
  --namespace monitoring
```

Le chart installe automatiquement :
- `prometheus-server` — le serveur principal
- `prometheus-node-exporter` — métriques système de chaque nœud
- `kube-state-metrics` — métriques des objets Kubernetes (pods, deployments…)
- `prometheus-alertmanager` — gestion des alertes

### 4 Vérifie que tous les pods sont en état `Running`

```bash
kubectl get pods -n monitoring
```

Attends que tous les pods soient `Running` avant de continuer (peut prendre 1–2 minutes) :

```bash
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=prometheus \
  -n monitoring --timeout=120s
```

### 5 Liste les services exposés

```bash
kubectl get svc -n monitoring
```

### 6 Expose `prometheus-server` en NodePort

```bash
kubectl patch svc prometheus-server \
  -n monitoring \
  -p '{"spec": {"type": "NodePort"}}'
```

Récupère le port attribué :

```bash
kubectl get svc prometheus-server -n monitoring \
  -o jsonpath='{.spec.ports[0].nodePort}' && echo
```

### 7 Accède à l'interface Prometheus

Ouvre ton navigateur sur :

```
http://192.168.56.12:<NODE_PORT>
```

Dans l'onglet **Status → Targets**, vérifie que les targets `node-exporter` et `kube-state-metrics` sont en état **UP**.

💡 **Questions :**
- Qu'est-ce qu'un *exporter* dans l'écosystème Prometheus ?
- Pourquoi Prometheus utilise-t-il un modèle pull plutôt que push ?
- Que signifie le statut **DOWN** sur une target ?

---

## PARTIE 2 — Installer Grafana

### 8 Ajoute le repo Helm de Grafana

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

### 9 Installe Grafana dans le namespace `monitoring`

```bash
helm install grafana grafana/grafana \
  --version 9.3.2 \
  --namespace monitoring
```

### 10 Vérifie que le pod Grafana est en état `Running`

```bash
kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana
```

### 11 Expose Grafana en NodePort

```bash
kubectl patch svc grafana \
  -n monitoring \
  -p '{"spec": {"type": "NodePort"}}'
```

Récupère le port attribué :

```bash
kubectl get svc grafana -n monitoring \
  -o jsonpath='{.spec.ports[0].nodePort}' && echo
```

### 12 Récupère les identifiants Grafana

Grafana stocke ses identifiants dans un Secret Kubernetes :

```bash
# Login admin
kubectl get secret grafana -n monitoring \
  -o jsonpath='{.data.admin-user}' | base64 -d && echo

# Mot de passe admin
kubectl get secret grafana -n monitoring \
  -o jsonpath='{.data.admin-password}' | base64 -d && echo
```

### 13 Accède à l'interface Grafana

Ouvre ton navigateur sur :

```
http://192.168.56.12:<NODE_PORT>
```

Connecte-toi avec les identifiants récupérés.

💡 **Questions :**
- Pourquoi les identifiants sont-ils stockés dans un Secret Kubernetes plutôt qu'en clair dans la configuration ?
- Comment modifier le mot de passe admin après installation ?

---

## PARTIE 3 — Connecter Prometheus à Grafana

### 14 Ajoute Prometheus comme source de données (Data Source)

Dans Grafana :

1. Va dans **Connections → Data sources**
2. Clique sur **Add data source**
3. Sélectionne **Prometheus**
4. Dans le champ **Prometheus server URL**, entre l'URL interne du service (résolution DNS interne au cluster) :

```
http://prometheus-server.monitoring.svc.cluster.local
```

5. Clique sur **Save & test** — le message `Data source is working` doit apparaître.

> Grafana est dans le même cluster que Prometheus : on utilise le DNS interne Kubernetes plutôt que le NodePort.

💡 **Questions :**
- Pourquoi utilise-t-on le DNS interne `prometheus-server.monitoring.svc.cluster.local` plutôt que l'IP du nœud ?
- Que se passe-t-il si tu entres une URL incorrecte dans le champ Prometheus server URL ?

---

## PARTIE 4 — Explorer les métriques et les dashboards

### 15 Exécute tes premières requêtes PromQL dans Grafana

Dans Grafana, va dans **Explore** et sélectionne la data source Prometheus.

Requêtes à tester :

```promql
# Utilisation CPU de chaque nœud (en %)
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Mémoire disponible sur chaque nœud (en octets)
node_memory_MemAvailable_bytes

# Nombre de pods en état Running par namespace
count by(namespace) (kube_pod_status_phase{phase="Running"})

# Nombre de redémarrages des conteneurs
kube_pod_container_status_restarts_total
```

💡 **Questions :**
- Que signifie `rate(...)` dans une requête PromQL ?
- Comment filtrer une métrique sur un nœud précis ?

---

### 16 Importe un dashboard communautaire pour K3s

Grafana propose des milliers de dashboards préconstruits sur [grafana.com/dashboards](https://grafana.com/grafana/dashboards/).

Dans Grafana :

1. Va dans **Dashboards → Import**
2. Entre l'ID du dashboard : **`15661`** (K8s Dashboard)
3. Sélectionne la data source **Prometheus** créée précédemment
4. Clique sur **Import**

Explore les panneaux : CPU, mémoire, réseau, pods par namespace.

💡 **Questions :**
- Quelle est la différence entre un dashboard importé et un dashboard personnalisé ?
- Comment sauvegarder un dashboard pour le versionner dans Git ?

---

### 17 Crée un dashboard personnalisé

Crée un nouveau dashboard avec au minimum deux panneaux :

**Panneau 1 — CPU par nœud :**

```promql
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

Type : `Time series` — Unité : `Percent (0-100)`

**Panneau 2 — Mémoire utilisée par nœud :**

```promql
100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)
```

Type : `Gauge` — Unité : `Percent (0-100)` — Seuils : vert < 70 %, orange < 85 %, rouge > 85 %

Sauvegarde le dashboard sous le nom `Mon cluster K3s`.

💡 **Questions :**
- Quel type de panneau (Time series, Gauge, Stat…) est le plus adapté pour afficher une valeur instantanée ?
- Comment partager un dashboard avec un collègue ?

---

## 📚 Pour aller plus loin

| Sujet | Lien |
|-------|------|
| Documentation Prometheus | [prometheus.io/docs](https://prometheus.io/docs/introduction/overview/) |
| Documentation Grafana | [grafana.com/docs](https://grafana.com/docs/grafana/latest/) |
| Référence PromQL | [prometheus.io/docs/prometheus/latest/querying](https://prometheus.io/docs/prometheus/latest/querying/basics/) |
| Dashboards communautaires | [grafana.com/grafana/dashboards](https://grafana.com/grafana/dashboards/) |
| Alertmanager | [prometheus.io/docs/alerting](https://prometheus.io/docs/alerting/latest/alertmanager/) |

---

**Atelier terminé ! Félicitations pour ton travail !**

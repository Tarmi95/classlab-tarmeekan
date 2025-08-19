
# Atelier 13 : Limitations des ressources dans kubernetes

> 🎯 Découvrir et maîtriser la configuration des **requests** et **limits** dans Kubernetes afin de contrôler l’utilisation des ressources CPU et mémoire des Pods.

Dans Kubernetes, il est important de gérer l’utilisation des ressources pour :
- Garantir la stabilité du cluster.
- Éviter qu’un Pod ne consomme toutes les ressources disponibles.
- Prioriser certains workloads via les classes QoS (**Guaranteed**, **Burstable**, **BestEffort**).


## PARTIE 1. Limitations de ressources dans des `pods`

#### 1. Créer un Pod nommé `nginx` avec limitations de ressources
- Utiliser l’image `nginx:1.28.0`.
- Définir :
  - `requests.cpu`: `100m`
  - `requests.memory`: `128Mi`
  - `limits.cpu`: `500m`
  - `limits.memory`: `256Mi`

#### 2. Vérifier la création
  ```bash
  kubectl describe pod nginx
  ```
- Vérifier que les requests et limits sont bien appliqués.

#### 3. Tester le dépassement de ressources**
- Déployer un conteneur qui consomme beaucoup de CPU ou mémoire pourobserver un étranglement des ressources (OOMKill).

#### 4. Observer la classe QoS
```bash
kubectl get pod nginx -o jsonpath='{.status.qosClass}'
```


---

### 💡 A savoir
- Pour connaître l’utilisation des ressources :
```bash
kubectl top pod
```


---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-14-namespace.md)

[Revenir à l'atelier precedent](atelier-12-monitoring.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



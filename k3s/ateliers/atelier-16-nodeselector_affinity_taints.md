
# Atelier 16 : NodeSelector, Node Affinity, Taints & Tolerations dans Kubernetes

> 🎯 À la fin de cet atelier, vous serez capable de :
- Contraindre le placement de pods sur des nœuds spécifiques avec **NodeSelector**.
- Utiliser **Node Affinity** pour exprimer des règles plus flexibles de placement.
- Comprendre et manipuler les mécanismes de **Taints** et **Tolerations** pour contrôler le scheduling.


## PARTIE 1. Ajouter un `Label` à un nœud 

- Listez les nœuds :
```bash
kubectl get nodes
```

- Ajoutez un `Label` au nœud `vm2` :
```bash
kubectl label node vm2 disktype=ssd
```

- Vérifiez :
```bash
kubectl get nodes --show-labels
```

---

## PARTIE 2. Utiliser `NodeSelector` 

- Créez un pod via le manifest `pod-nodeselector.yaml` qui ne peut tourner que sur les nœuds avec `disktype=ssd`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-nodeselector
spec:
  containers:
  - name: nginx
    image: nginx:1.28.0
  nodeSelector:
    disktype: ssd
```

- Appliquez et observez :
```bash
kubectl apply -f pod-nodeselector.yaml
```

- Observez :
```bash
kubectl get pod -o wide
```

---

## PARTIE 3. Utiliser `Node Affinity` 

- Créez un pod via le manifest `pod-nodeaffinity.yaml` avec une affinité plus expressive.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-nodeaffinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd
  containers:
  - name: nginx
    image: nginx:1.28.0
```

- Appliquez :
```bash
kubectl apply -f pod-nodeaffinity.yaml
```

- Vérifiez :
```bash
kubectl get pod -o wide
```

---

## PARTIE 4. `Taints & Tolerations` 

- Ajoutez une **taint** au nœud  `vm2` et `vm3`:
```bash
kubectl taint nodes vm2 role=test:NoSchedule
kubectl taint nodes vm3 role=test:NoSchedule
```

- Verifiez la présence d'un **taint** aux nœuds:
```bash
kubectl describe node vm2 | grep Taints
kubectl describe node vm3 | grep Taints
```

- Essayez de programmer un pod sans tolération :
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-sans-toleration
spec:
  containers:
  - name: nginx
    image: nginx:1.28.0
```

Le pod restera en état `Pending`.

- Ajoutez ensuite une tolération pour qu’il s’exécute :
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-avec-toleration
spec:
  tolerations:
  - key: "role"
    operator: "Equal"
    value: "test"
    effect: "NoSchedule"
  containers:
  - name: nginx
    image: nginx:1.28.0
```

---

## PARTIE 5.  Nettoyage
- Suppression pods :
```bash
kubectl delete pod pod-nodeselector pod-nodeaffinity pod-sans-toleration pod-avec-toleration --force=true
```

- Suppression taint :
```bash
kubectl taint nodes vm2 vm3 role-
```

- Suppression label :
```bash
kubectl label node vm2 disktype-
```

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-17-gestion_des_acces.md)

[Revenir à l'atelier precedent](atelier-15-labels_selectors.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



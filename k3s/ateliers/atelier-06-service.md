
# Atelier 6 : Service 

> 🎯 **Dans cet atelier, nous allons explorer les differents type de Service Kubernetes (ClusterIP, NodePort et LoadBalancer), tout en comprenant les différences entre chaque type de service.**  



## PARTIE 1. Explorer les `Service` kubernetes

#### 1. Créer le pod `python-app`:
```bash
kubectl run python-app --image=ftutorials/python-app --port=5000
```

#### 2. Verifier la creation du pod `python-app`:
```bash
kubectl get pod
```

#### 3. Créer un service de type `ClusterIP` nommé `python-clusterip` sur le pod `python-app` :
```bash
kubectl expose pod python-app --name=python-clusterip --port=5000
```

- **ClusterIP** crée une IP interne au cluster, accessible uniquement depuis d’autres pods.  
- **Pas** d’accès externe direct.

#### 3. Créer un service de type `NodePort` nommé `python-nodeport` sur le pod `python-app` :
```bash
kubectl expose pod python-app --name=python-nodeport --type=NodePort --port=5000
```

- **NodePort** expose le port sur chaque nœud du cluster (30000–32767).  
- Accessible depuis l’extérieur via `http://<IP_NŒUD>:<NODE_PORT>`.  

#### 4. Créer un service de type `LoadBalancer` nommé `python-lb` sur le pod `python-app` :
```bash
kubectl expose pod python-app --name=python-lb --type=LoadBalancer --port=5000
```

- **LoadBalancer** fournit une **EXTERNAL-IP**  
- Idéal pour production.

---

#### 4. Tests et comparaisons

| Type         | Accessible depuis…                           | Usage                            |
|--------------|----------------------------------------------|----------------------------------|
| ClusterIP    | Seulement depuis d’autres pods (`curl python-clusterip:5000`) | Services internes                |
| NodePort     | `http://<IP_ Nœud>:<NodePort>`              | Test local / accès simple        |
| LoadBalancer | `http://<EXTERNAL-IP>:5000`                  | Production, accès public direct  |

---

#### 5. Nettoyage
```bash
kubectl delete svc python-clusterip python-nodeport python-lb
kubectl delete pod python-app --force=true
```

#### 6. Vérifier qu’il ne reste aucun pod et svc :
```bash
kubectl get pods,svc
```

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-07-stockage_persistent.md)

[Revenir à l'atelier precedent](atelier-05-deployment.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



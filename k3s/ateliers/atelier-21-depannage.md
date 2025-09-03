
# Atelier 21 : Guide de Dépannage Kubernetes (Troubleshooting)

> 🎯 Ce guide permet de diagnostiquer rapidement les problèmes courants liés aux Pods, Services et Ingress dans Kubernetes.  


## PARTIE 1. Guide

### Étape 1 – Pods en état `PENDING`
- **Cluster plein ?**  
  - ✅ Oui → **Augmentez la taille du cluster**  
  - ❌ Non → Vérifiez si un **ResourceQuota** est atteint  
    - ✅ Oui → **Repoussez les limites ResourceQuota**  
    - ❌ Non → Vérifiez les **PersistentVolumeClaim (PVC)**  
      - ✅ PVC en `PENDING` → **Corrigez le PVC**  
      - ❌ Autre → **Problème du Scheduler**

---

### Étape 2 – Pods en état `RUNNING` mais non accessibles
- **Application joignable ?**  
  - ✅ Oui → Tout fonctionne  
  - ❌ Non → Vérifiez le **Service**  
    - `targetPort` correspond-il au `containerPort` du Pod ?  
      - ❌ Non → **Corrigez targetPort/containerPort**  
      - ✅ Oui → Vérifiez le **selector**  
        - ❌ Non → **Corrigez le selector pour correspondre au Pod**  
        - ✅ Oui → Problème probable du **Kube Proxy**

---

### Étape 3 – Pods en état `READY`
- ❌ Non → Vérifiez les sondes :  
  - **Readiness probe échoue ?** → **Corrigez la sonde de Readiness**  
  - **Liveness probe échoue ?** → **Corrigez la sonde de Liveness**

---

### Étape 4 – Problèmes de conteneurs
- **CrashLoopBackOff**  
  - Application défaillante ? → **Corrigez l’application**  
- **ImagePullBackOff**  
  - Vérifiez : nom d’image, tag, registry privée  
  - Corrigez ou configurez un secret pour registry privée

---

### Étape 5 – Ingress et exposition
- **Ingress fonctionne ?**  
  - ✅ Oui → Testez depuis Internet public  
  - ❌ Non → Vérifiez :  
    - `serviceName` et `servicePort` du backend  
    - Liste des backends disponibles  
  - Si toujours KO → Problème du **Ingress Controller**

---

### Commandes utiles
```bash
# Lister les pods
kubectl get pods

# Logs d’un pod
kubectl logs <pod-name>

# Logs d’un pod précédent (après redémarrage)
kubectl logs <pod-name> --previous

# Décrire un pod
kubectl describe pod <pod-name>

# Vérifier un service
kubectl describe service <service-name>

# Vérifier un ingress
kubectl describe ingress <ingress-name>
```

---

## PARTIE 2. Schéma

```
Pods PENDING?
   ├── Oui → Cluster plein? → Oui: Augmentez cluster
   │                         └─ Non: ResourceQuota atteint?
   │                                   ├── Oui: Ajustez quota
   │                                   └─ Non: PVC PENDING?
   │                                             ├── Oui: Corrigez PVC
   │                                             └─ Non: Scheduler
   └── Non → Pods RUNNING?
              ├── Non → Logs/Describe → Corrigez App / Dockerfile
              └── Oui → READY?
                       ├── Non: Vérifiez Readiness/Liveness
                       └── Oui → Accessible?
                                 ├── Non: Service targetPort/selector
                                 └── Oui → Vérifiez Ingress / Exposition
```

---

### Atelier terminé ! Félicitations !!!


[Revenir à l'atelier precedent](atelier-20-kustomize.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



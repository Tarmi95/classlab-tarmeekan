
# Atelier 1 : Déploiement de Dashboard

> 🎯 **Déployer un dashboard dans Kubernetes pour se familiariser avec les concepts, ressources et fonctionnalités clés de Kubernetes.**  

## PARTIE 1. `Kubernetes Dashboard`

#### 1. Installer `Kubernetes Dashboard`

Ajouter le dépôt Helm :

```bash
helm repo add k8s-dashboard https://kubernetes.github.io/dashboard
```

Installer la version 6.0.8 :

```bash
helm install kubernetes-dashboard k8s-dashboard/kubernetes-dashboard \
  --create-namespace \
  --namespace kubernetes-dashboard \
  --version 6.0.8
```

#### 2. Exposer le Kubernetes Dashboard à l'exterieur du cluster

```bash
kubectl patch svc kubernetes-dashboard \
  -n kubernetes-dashboard \
  -p '{"spec": {"type": "LoadBalancer"}}'
```

Attendez quelques secondes, puis vérifiez l’IP externe :

```bash
kubectl -n kubernetes-dashboard get svc kubernetes-dashboard
```

#### 3. Attribuer des droits d'accès 

```bash
kubectl create clusterrolebinding kubernetes-dashboard \
  --serviceaccount=kubernetes-dashboard:kubernetes-dashboard \
  --clusterrole=view
```

Générer un token d'accès d'une durée determinée :

```bash
kubectl create token kubernetes-dashboard \
  --duration=2160h \
  -n kubernetes-dashboard
```

#### 4. Accéder et se connecter au kubernetes Dashboard

Ouvrir votre navigateur et aller à :

**[https://192.168.56.241/#/login](https://192.168.56.241/#/login)**

Sur la page d’accueil du Dashboard, sélectionner “Jeton”.


Ignorer l’avertissement de certificat auto‑signé (Accepter le risque).


Coller le token de kubernetes-dashboard généré précédemment.


Connexion (Valider) : Vous arrivez alors sur l’interface graphique du Kubernetes Dashboard.

---

## PARTIE 2. `SKOONER`

#### 1. Installer `Skooner`

```bash
kubectl apply -f /vagrant/k3s/skooner.yaml
```

#### 2. Verifier

```bash
kubectl get pod,svc -n kube-system -l k8s-app=skooner
```

Sortie attendu :

```bash
NAME                           READY   STATUS    RESTARTS   AGE
pod/skooner-5845c48d74-zvwc8   1/1     Running   0          20s

NAME              TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/skooner   NodePort   10.43.128.112   <none>        80:30080/TCP   21s
```

#### 3. Accéder et se connecter au kubernetes Dashboard

Ouvrir votre navigateur et aller à :

**[http://192.168.56.13:30080/](http://192.168.56.13:30080/)**

Sur la page d’accueil de Skooner, coller le token de kubernetes-dashboard généré précédemment.


Cliquer sur GO : Vous arrivez alors sur l’interface graphique de Skooner.

---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-02-pod.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



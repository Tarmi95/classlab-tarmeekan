
# Atelier 9 : Ingress Kubernetes

> 🎯 **Exposer deux services (`quiz-app-svc` et `quiz-docker-svc`) avec un seul point d’entrée HTTP en utilisant un **Ingress** et faire du routage basé sur le nom d’hôte (`quiz-app.local` et `quiz-docker.local`).**  

## PARTIE 1. Mettre en place `Ingress` Kubernetes

### Documentation :

[https://kubernetes.io/docs/concepts/services-networking/ingress/](https://kubernetes.io/docs/concepts/services-networking/ingress/)


[https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)


### Etapes à suivre :

#### 1. Assurez vous d'avoir un **Ingress Controller** installé sur votre cluster kubernetes. 

#### 2. Créer les applications backend (Deployments + Services ClusterIP)

- Déployer `quiz-app`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quiz-app
  labels:
    app: quiz-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: quiz-app
  template:
    metadata:
      labels:
        app: quiz-app
    spec:
      containers:
      - name: quiz-app
        image: ftutorials/quiz:devops
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: quiz-app-svc
  labels:
    app: quiz-app
spec:
  selector:
    app: quiz-app
  ports:
  - name: http
    protocol: TCP
    port: 80       
    targetPort: 3000   
  type: ClusterIP  
```

- Déployer `quiz-docker`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quiz-docker
  labels:
    app: quiz-docker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: quiz-docker
  template:
    metadata:
      labels:
        app: quiz-docker
    spec:
      containers:
      - name: quiz-docker
        image: ftutorials/quiz:version4
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: quiz-docker-svc
  labels:
    app: quiz-docker
spec:
  selector:
    app: quiz-docker
  ports:
  - name: http
    protocol: TCP
    port: 80       
    targetPort: 3000   
  type: ClusterIP  
```

#### 3. Recuperez un modèle de manifest Ingress dans la documentation kurbenetes afin de creer `ingress-hosts.yaml` adapté à votre besoin.

#### 3. Vérifiez que les deployments, pods et services sont en place et fonctionnels

#### 4. Appliquer l’Ingress
```bash
kubectl apply -f ingress-hosts.yaml
```

#### 5. Vérifiez qu’il a été créé :
```bash
kubectl get ingress 
```

#### 6. Modifier le fichier hosts (sur la machine cliente)
Ajoutez les lignes suivantes pour que les noms d’hôte pointent vers l’IP exposée de l’ingress controller (exemple `192.168.56.240`) :
```
192.168.56.240 quiz-app.local
192.168.56.240 quiz-docker.local
```
(Adaptez l’IP à celle de votre controller, par exemple la `EXTERNAL-IP` ou Node IP).

#### 7. Tester le routage via curl ou le navigateur web
```bash
curl -v http://quiz-app.local/
curl -v http://quiz-docker.local/
```
Résultat attendu : chaque hôte retourne la réponse du service correspondant.


---

### Atelier terminé ! Félicitations !!!


[Passer à l'atelier suivant](atelier-9-ingress.md)

[Revenir à l'atelier precedent](atelier-8-deploiement_app_bdd.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://www.docker.com/)
- [Documentation K3S](https://k3s.io/)



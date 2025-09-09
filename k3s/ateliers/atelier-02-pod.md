
# Atelier 2 : Pod

> 🎯 **Un Pod est l’unité de base d’exécution dans Kubernetes. L’objectif de l'atelier est de comprendre, manipuler et tester le comportement des Pods dans Kubernetes à travers des travaux pratiques concrets.**  

### Rappel :

`kubectl` est l'utilitaire en ligne de commande pour interagir avec un cluster Kubernetes. Elle suit une structure simple :

```bash
kubectl [commande] [ressource] [nom] [options]
```

### Exemples :
- `kubectl get pods` → liste tous les pods.
- `kubectl describe pod nginx` → affiche les détails du pod nginx.
- `kubectl delete pod alpine` → supprime le pod alpine.

## PARTIE 1. Création de `pod` avec `kubectl`


#### 1. Vérifier le contexte du cluster :
```bash
kubectl config current-context
```
Résultat attendu : le nom du cluster actif.

#### 2. Afficher l’aide de la commande `kubectl run` :
```bash
kubectl run --help
```
Cela permet de voir toutes les options possibles ainsi que des exemples pour cette commande. 

#### 3. Créer un pod nommé `nginx` avec comme image `nginx:1.28.0` :

```bash
kubectl run nginx --image=nginx:1.28.0
```

#### 4. Lister les pods :
```bash
kubectl get pods
```
Le pod `nginx` doit apparaître avec le statut `Running`.

---


## PARTIE 2. Gestion d’un pod

#### 1. Afficher les détails du pod :
```bash
kubectl describe pod nginx
```
Vous verrez des infos comme : l'IP, le conteneur, l'image, le statut, les événements....

#### 2. Recuperer l'adresse IP du pod `nginx` et tester la connectivité avec `ping` : 
```bash
ping -c 4 <IP_nginx>
```
### ⚠️ **Pourquoi le ping échoue-t‑il ?**

#### 3. Lancer un Pod en mode interactif nommé `alpine` avec comme image `alpine:3.22` et en executant un `shell` :
```bash
kubectl run -it alpine --image=alpine:3.22 sh
```

- Installer curl via le gestionnaire de paquets `apk` :
```bash
apk --update add curl
```

- Lancer la commande `curl` avec l'adresse IP du pod `nginx` :
```bash
curl <IP_nginx>
```
Résultat attendu : contenu HTML de la page NGINX.

- Tester la resolution DNS du pod `nginx` :
```bash
curl nginx
```
### ⚠️ **Pourquoi la résolution DNS du nginx échoue-t‑elle ?**

#### 4. Lire les logs du pod `nginx` :
```bash
kubectl logs nginx
```
ou

```bash
kubectl logs nginx --container=nginx
```
Résultat attendu : logs générés par nginx.

#### 5. supprimer le pod `nginx` :
```bash
kubectl delete pod nginx
```

#### 6. supprimer le pod `alpine` sans attendre la période de grâce Kubernetes :
```bash
kubectl delete pod alpine --grace-period=0 --force
```

#### 7. Vérifier qu’il ne reste aucun pod :
```bash
kubectl get pods
```

---

## PARTIE 3. Exposer des pods à l'extérieur via des services

#### 1. Créer un pod nommé `nginx` avec comme image `nginx:1.28.0` :

```bash
kubectl run nginx --image=nginx:1.28.0
```

#### 2. Vérifier que le pod nginx est bien en cours d’exécution :
```bash
kubectl get pods
```
Le pod `nginx` doit apparaître avec un statut `Running`.

#### 3. Consulter l’aide de la commande `kubectl expose` :
```bash
kubectl expose --help
```
`expose` permet de créer un Service à partir d’une ressource existante.

#### 4. Créer un service de type NodePort sur le pod `nginx` :
```bash
kubectl expose pod nginx --type=NodePort --port=80
```
Un service sera créé et attribuera automatiquement un port entre `30000` et `32767`.

#### 5. Vérifier la création du service :
```bash
kubectl get service
```
Rechercher la colonne `PORT(S)` avec le format `80:<nodePort>/TCP`.


#### 6. Tester l'accès au pod via un autre pod avec curl

Comprendre la différence entre accéder directement à un pod (**IP éphémère**) et accéder à un **service (IP stable)**.

- Créer un pod interactif `alpine` pour tester depuis un autre conteneur :
```bash
kubectl run -it alpine --image=alpine:3.22 sh
```

- Installer `curl` dans le pod `alpine` :
```bash
apk --update add curl
```

- Récupérer l'IP du service :
```bash
kubectl get service nginx
```
Notez la colonne `CLUSTER-IP` (ex. : `10.43.72.183`)

Tester avec curl depuis `alpine` :
```bash
curl <CLUSTER-IP>
```
Résultat attendu : page HTML **"Welcome to nginx!"**

Si le test échoue :
- Vérifiez que le service est bien associé au bon pod.
- Vérifiez que le port est correct.
- Vérifiez que le pod `nginx` est `Running`.

Tester via le nom DNS du service :
```bash
curl nginx
```
Résultat attendu : page HTML **"Welcome to nginx!"**

### 💡 A savoir
- L’IP du **service** est **stable**, contrairement à celle d’un pod.
- Kubernetes offre un système DNS interne pour référencer les services par **nom**.

```
# Schéma d’un Service Kubernetes

                      ┌───────────────────────┐
                      │       Service         │
                      │ app=nginx, env=prod   │
                      │   (IP + DNS stables)  │
                      └───────────┬───────────┘
                                  │
         ┌────────────────────────┼─────────────────────────┐
         │                        │                         │
 ┌─────────────┐          ┌─────────────┐           ┌─────────────┐
 │   Pod 1     │          │   Pod 2     │           │   Pod 3     │
 │ app=nginx   │          │ app=nginx   │           │ app=nginx   │
 │ env=prod    │          │ env=prod    │           │ env=prod    │
 └─────────────┘          └─────────────┘           └─────────────┘


```


#### 7. Test depuis un navigateur Web :

- Récupérer le port NodePort du service :
```bash
kubectl get service nginx
```
Repérez la partie `30000-32767` dans `PORT(S)`.

- Identifier l’IP du nœud qui hébèrge le pod `nginx` :

```bash
kubectl describe pod nginx | grep Node
```

- Ouvrir un navigateur et saisir :
```
http://<IP_NODE>:<NODE_PORT>
```

Résultat attendu : la **page d’accueil de nginx** s’affiche.


#### 8. Supprimer le service `nginx`:
```bash
kubectl delete service nginx
```

#### 9. Supprimer les pods `nginx` et `alpine` sans attendre la période de grâce Kubernetes :
```bash
kubectl delete pod nginx alpine --force=true
```

#### 10. Vérifier qu’il ne reste aucun pod :
```bash
kubectl get pods
```
---

## PARTIE 4. De Dockerfile à Pod

#### À partir d’une application nommée `python-app` dont le code source est sur [https://gitlab.com/ftutorials-projets/python-app](https://gitlab.com/ftutorials-projets/python-app), contenant déjà un Dockerfile, vous devez :

#### 1. Construire une image Docker.

#### 2. Publier cette image sur Docker Hub.

#### 3. Creer un pod avec l’image.

#### 4. Exposer le pod avec un service de type NodePort.

#### 5. Tester l’application via un navigateur web.

---

### Atelier terminé ! Félicitations !!! Pensez à supprimer vos ressources pour maintenir un environnement propre.


[Passer à l'atelier suivant](atelier-03-manifests_kubernetes.md)

[Revenir à l'atelier precedent](atelier-01-dashboard.md)


[Retour à la page démarrer avec kubernetes](../README.md)


## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)



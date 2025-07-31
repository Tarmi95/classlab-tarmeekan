
# Docker

### 1. Installer docker sur `VM1`

L'action est à réaliser sur `VM1` depuis le répertoire personnel de vagrant.

```bash
vagrant ssh VM1
```

```bash
ansible-playbook /vagrant/ansible/playbooks/docker-install.yaml
```

Afin de permettre à l’utilisateur `vagrant` d’exécuter `Docker` sans utiliser `sudo`, une deconnexion et reconnexion à la box vagrant `VM1` peut être necessaire.


### 2. Lancer un conteneur Docker

Les actions sont à réaliser sur `VM1`.

```bash
vagrant ssh VM1
```

Lances une application web dans un conteneur Docker nommée `quiz-app` basée sur l’image `ftutorials/quiz:version1`. L’application tourne à l’intérieur du conteneur sur le port 3000, mais tu y accèdes depuis le navigateur de ta machine via le port 80.

```bash
docker run -d -p 80:3000 --name quiz-app ftutorials/quiz:version1
```

Vérifie que le conteneur tourne :

```bash
docker container ls
```

Accède à l'application afin d'effectuer le Quiz :

**[http://192.168.56.11](http://192.168.56.11)**


### 3. Arrêter le conteneur

Avec le nom du conteneur :

```bash
docker stop quiz-app
```
Arrêter le conteneur libère les ressources, mais ne supprime pas le conteneur. Tu peux le redémarrer plus tard.

### 4. Redémarrer le conteneur arrêté

Avec le nom du conteneur :

```bash
docker start quiz-app
```

### 5. Supprimer le conteneur

```bash
docker rm -f quiz-app
```

Si le conteneur est encore en cours d’exécution, `-f` force la suppression.

### 6. Afficher tous les conteneurs, qu’ils soient en cours d’exécution, arrêtés, ou terminés.

```bash
docker container ls -a
```

### 7. Afficher tous les images Docker

```bash
docker image ls
```

### 8. Supprimer l’image Docker si elle n’est plus nécessaire

```bash
docker image rm ftutorials/quiz:version1
```

### 9. Nettoyer les ressources inutilisées dans Docker

```bashs
docker system prune -a -f
```

---

## 📚 Pour aller plus loin

- [Documentation Docker](https://www.docker.com/)
- [Retour en arrière](../README.md)


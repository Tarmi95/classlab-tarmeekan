# Atelier 1 : Dockerfile

> 🎯 Ce repo contient une application Node.js, et vous devez la faire fonctionner dans un conteneur.
Aucune modification de l'application ne devrait être nécessaire, seules les modifications du Dockerfile dans ce répertoire sont requises. 

## Contexte

- Imaginez qu'un autre développeur vous ait donné les instructions ci-dessous, et vous devrez les interpréter pour déterminer ce que le Dockerfile doit contenir.
- Une fois que le Dockerfile se construit correctement, démarrez le conteneur localement pour vérifier qu'il fonctionne via le navigateur web.
- Poussez ensuite l'image sur Docker Hub, et allez sur [https://hub.docker.com](https://hub.docker.com) pour vérifier que vous l'avez correctement poussée.
- Supprimez ensuite l'image locale du cache (`docker image rm <name>`)
- Ensuite, démarrez un nouveau conteneur à partir de votre image sur Hub, et observez comment il se télécharge et s'exécute automatiquement.
- Testez à nouveau que cela fonctionne via le navigateur web.

## Instructions du développeur de l'application

- Vous devez utiliser l'image officielle node légère, avec la branche alpine 23.x (`node:23-alpine`).
- Cette application écoute sur le port 3000, mais le conteneur doit écouter sur le port 8088 de l'hôte Docker, afin qu'il réponde à [http://localhost:8088](http://localhost:8088) sur votre ordinateur.
- Definissez `/app` comme le répertoire de travail de l'application.
- Copiez les fichiers package.json et package-lock.json pour installer les dépendances.
- Ensuite copiez les fichiers sources src et public de l'application dans le conteneur.
- Installez les dépendances, construisez l'application et nettoyez les modules Node.js en executant les commandes `npm install`, `npm install -g serve `,`npm run build` et `rm -fr node_modules`.
- Demarrez l'application avec la commande serve -s build. Assurez-vous d'utiliser la syntaxe de tableau JSON pour la commande CMD. (`CMD [ "something", "something" ]`).
- À la fin, vous devez utiliser les commandes FROM, WORKDIR, COPY, RUN, EXPOSE, et CMD.

## A savoir

Cet atelier est simplement conçu pour vous initier aux concepts de base des Dockerfile et ne se concentre pas trop sur l'utilisation correcte de Node.js dans un conteneur. 

---

### Atelier terminé ! Félicitations !!!


[Retour à la page démarrer avec Docker](../../../docker/README.md)


## 📚 Pour aller plus loin

- [Documentation Docker](https://docs.docker.com/)
- [Reference Dockerfile](https://docs.docker.com/reference/dockerfile/)


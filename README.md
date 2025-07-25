
# ClassLab

Bienvenue dans ce **LAB** pour pratiquer sereinement !  

> 🎯 L'objectif de ce lab est de donner à chaque apprenant un environnement identique, sans effectuer des modifications majeures sur son PC personnel ni dépendre des configurations locales.

---

⚠️ **IMPORTANT** :  
**LES IMAGES DOCKER DE CE LAB SONT RÉSERVÉES À DES FINS DE TEST ET D’APPRENTISSAGE UNIQUEMENT !**  ➡️ **NE PAS LES UTILISER DANS UN  ENVIRONNEMENT DE PRODUCTION.**

---

## Les outils à disposition dans ce lab

- `Docker` : Outil de conteneurisation.
- `Kubernetes` : Outil d'orchestration des conteneurs.
- `Ansible` :  Outil de gestion de la configuration et de déploiement.

---


## ✅ Pré-requis 

**Ce dont tu auras besoin :**

- Un ordinateur portable avec au moins 8 Go de RAM (16 Go est préférable)
- Environ 50 Go d'espace disque de disponible
- Un système d'exploitation Windows, MacOS, ou Linux
- Etre administrateur de l'ordinateur portable
- L'option de Virtualisation doit être activé dans le BIOS
- un accès à internet
- Quelques heures de disponibilité pour pratiquer

---

## **Avant de commencer sur `WINDOWS` :**  

➡️ Pour la partie `Windows`, cliques [ici](./windows/README.md) !

---

## **Avant de commencer sur `MacOS` :**  

➡️ Pour la partie `MacOS`, cliques [ici](./macos/README.md) !

---

## **Avant de commencer sur `Linux Ubuntu` :**  

➡️ Pour la partie `Linux Ubuntu`, cliques [ici](./linux/README.md) !

---


## 🚀 Comment utiliser le LAB

Commencer par creer un nouveau dossier ou se positionner dans un dossier de ton choix. 

### 1. Cloner le projet

```bash
git clone https://gitlab.com/ftutorials-projets/classlab.git
```

N'hésites pas à utiliser la méthode de ton choix.

### 2. Demarrer les machines virtuelles depuis ton terminal

```bash
cd classlab 
```

```bash
vagrant up 
```

Il faut compter en moyenne environ **`8 minutes`** pour le demarrage et la configuration des machines virtuelles.

### 3. Afficher la liste générale des commandes disponibles dans Vagrant

```bash
vagrant help
```


### 4. Lister et voir l'état des machines virtuelles depuis ton terminal

```bash
vagrant status
```

### 5. Tester la connexion SSH depuis ton terminal

```bash
vagrant ssh VM1  
vagrant ssh VM2 
vagrant ssh VM3  
```

### 6. Arrêter les machines virtuelles depuis ton terminal

```bash
vagrant halt 
```

---

## Docker

➡️ Pour la partie `Docker`, cliques [ici](./docker/README.md) !

---

## Kubernetes avec K3S

➡️ Pour la partie `Kubernetes avec K3S`, cliques [ici](./k3s/README.md) !

---

## Machines virtuelles (VMs) avec Vagrant

➡️ Pour la partie `Machines virtuelles`, cliques [ici](./vms/README.md) !

---

## 📚 Pour aller plus loin

- [Documentation Docker](https://www.docker.com/)
- [Documentation Kubernetes](https://kubernetes.io/)
- [Documentation K3S](https://k3s.io/)
- [Documentation Vagrant](https://developer.hashicorp.com/vagrant)
- [Documentation Ansible](https://docs.ansible.com/)


---


# MacOS

- [Installes Homebrew](https://brew.sh/fr/)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Le script explique ce qu’il va faire, puis fait une pause avant de l’exécuter. Plus d’options d’installation sont disponibles [ici](https://docs.brew.sh/Installation).


Après l'instaion d'Homebrew crées un fichier dans le repertoire personnel de ton utilisateur nommé .curlrc avec comme contenu "-k" :

```bash
echo-k > ~/.curlrc
```

```bash
cat ~/.curlrc
```

- [Installes virtualbox (Ne pas faire pour MacOS M1/M2)](https://formulae.brew.sh/cask/virtualbox#default)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
brew install --cask virtualbox
```

- [Installes vagrant](https://formulae.brew.sh/cask/vagrant#default)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
brew install --cask vagrant
```

```bash
brew install --cask vagrant-manager
```

- [Installes git](https://formulae.brew.sh/formula/git#default)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
brew install git
```

- [Installes Visual Studio Code](https://formulae.brew.sh/cask/visual-studio-code#default)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
brew install --cask visual-studio-code
```

**`Les installations ci-dessous concernent uniquement les MacOS M1/M2`** :

- [Installes rosetta (Pour MacOS M1/M2)](https://techcommunity.microsoft.com/blog/intunecustomersuccess/support-tip-install-rosetta-2-on-new-apple-silicon-m1-macs-to-run-apps-built-for/2087631)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
/usr/sbin/softwareupdate --install-rosetta --agree-to-license
```

Crées un compte sur le site de [Broadcom](https://profile.broadcom.com/web/registration) afin de pouvoir telecharger et installer VMWare Fusion Tech Preview :

**`VMware Cloud Foundation => My Downloads => VMware Fusion => VMware Fusion 13 Pro Personal Use => 13.6 => Download`**

VMware Fusion/Pro 13 License Keys, uniquement pour les tests :

```bash
4A4RR-813DK-M81A9-4U35H-06KND
NZ4RR-FTK5H-H81C1-Q30QH-1V2LA
4C21U-2KK9Q-M8130-4V2QH-CF810
MC60H-DWHD5-H80U9-6V85M-8280D
JU090-6039P-08409-8J0QH-2YR7F
4Y09U-AJK97-089Z0-A3054-83KLA
```

*`Penses à autoriser VMware Fusion dans la sécurité d'accessibilité et les paramètres de confidentialité de ton Mac.`*

- [Installes vagrant VMware](https://formulae.brew.sh/cask/vagrant-vmware-utility#default)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
brew install --cask vagrant-vmware-utility
```

- [Installes VMware plugin pour vagrant
](https://developer.hashicorp.com/vagrant/docs/providers/vmware/installation)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
vagrant plugin install vagrant-vmware-desktop
```


---

[Retour en arrière](../README.md)
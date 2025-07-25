# Linux Ubuntu 

- [Installes Virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
sudo apt update
sudo apt install curl wget gnupg2 lsb-release -y
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/vbox.gpg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
```

```bash
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
```

```bash
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
sudo apt install virtualbox-7.1 -y
```

```bash
sudo usermod -aG vboxusers $USER
newgrp vboxusers
```

- [Installes Vagrant]()

Ouvres une fenêtre du `Terminal` et executes : 

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```bash
sudo apt update
sudo apt install vagrant -y
sudo apt install libarchive-dev libarchive-tools -y
```

- [Installes Git](https://git-scm.com/downloads/linux)

Ouvres une fenêtre du `Terminal` et executes : 

```bash
sudo apt install git -y
```

- [Installes Visual Studio Code](https://code.visualstudio.com/download)

---

[Retour en arrière](../README.md)
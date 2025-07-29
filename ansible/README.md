
# Ansible

**Ansible est installé sur `VM1`.** 

### 1. Afficher la version d'Ansible

```bash
vagrant ssh VM1  # ansible controleur
```

```bash
ansible --version
```
La version installée `ansible [core 2.18.5]`


### 2. Consulter le fichier d'inventaire

Les actions sont à réaliser depuis la `VM1`.

```bash
cat /home/vagrant/hosts
```

Ou executes la commande ci-dessous depuis le répertoire personnel de vagrant :

```bash
ansible-inventory --list -y
```

### 3. Tester la connectivité avec hôtes distants (`VM2` et `VM3`)

Les actions sont à réaliser sur `VM1` depuis le répertoire personnel de vagrant.

```bash
ansible all -m ping
```

Sortie de commande attendu : 

```bash
192.168.56.13 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
192.168.56.12 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

En utilisant ansible-playbook : 


```bash
ansible-playbook /vagrant/ansible/playbooks/ping.yaml
```

---

## 📚 Pour aller plus loin

- [Documentation Ansible](https://docs.ansible.com/)
- [Retour en arrière](../README.md)


---


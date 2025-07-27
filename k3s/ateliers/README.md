
# Kubernetes avec K3S

Un cluster kubernetes K3S composé de deux machines virtuelles sous l'OS Ubuntu 24.04 sera installé. `VM2` *(node controleur)* et `VM3` *(node agent)*.

### 1. Déploiement de K3S via un playbook ansible

L'action est à réaliser sur `VM1` depuis le répertoire personnel de vagrant.

```bash
vagrant ssh VM1
```

```bash
ansible-playbook /vagrant/ansible/playbooks/k3s-deploiement.yaml
```

Sortie attendu :

```bash
PLAY RECAP *******************************************************************************************************
192.168.56.12              : ok=17   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
192.168.56.13              : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


Il faut compter en moyenne environ **`5 minutes`** pour le deploiement du cluster kubernetes k3s.

Pour quitter une box vagrant taper *`exit`*.

### 2. Se connecter sur K3S node controleur

```bash
vagrant ssh VM2  # k3s node controleur
```

### 3. Tester le bon fonctionnement de k3s 

Les actions sont à réaliser sur `VM2` depuis le répertoire personnel de vagrant.

Verifier que l'etat du service k3s est en cours d'éxecution :

```bash
systemctl status k3s
```

Pour quitter la commande taper *`q`*.

Lister tous les nœuds membres du cluster Kubernetes :

```bash
kubectl get nodes
```

Sortie attendu : 

```bash
NAME   STATUS   ROLES                  AGE   VERSION
vm2    Ready    control-plane,master   21m   v1.32.3+k3s1
vm3    Ready    <none>                 20m   v1.32.3+k3s1
```

Lister tous les pods de tous les namespaces du cluster :

```bash
kubectl get pods -A
```

Sortie attendu : 

```bash
NAMESPACE        NAME                                      READY   STATUS      RESTARTS      AGE
kube-system      coredns-7588999887-rzlxz                  1/1     Running     0             13m
kube-system      helm-install-traefik-crd-446hd            0/1     Completed   0             13m
kube-system      helm-install-traefik-grvpq                0/1     Completed   2             13m
kube-system      local-path-provisioner-774c6665dc-dqlrh   1/1     Running     0             13m
kube-system      metrics-server-6f4c6675d5-w7cxl           1/1     Running     0             13m
kube-system      traefik-67bfb46dcb-mst6l                  1/1     Running     0             12m
metallb-system   controller-bb5f47665-djrjk                1/1     Running     0             12m
metallb-system   speaker-b4kwz                             1/1     Running     0             12m
metallb-system   speaker-k8pnl                             1/1     Running     0             12m
```

Si tu as 0/1 `CrashLoopBackOff` ou `Pending` pour le pod CoreDNS  :

```bash
kubectl -n kube-system rollout restart deployment coredns
```

Cette commande provoque le remplacement de ou des pods un par un.

### 4. Gestion du cluster kubernetes depuis `VM1`

Les actions sont à réaliser sur `VM1` depuis le répertoire personnel de vagrant.

```bash
vagrant ssh VM1
```

```bash
sudo /vagrant/setup-helm-kubectl-vm1.sh
```
Le script est à executer une seule fois, lors de la première connexion sur `VM1`.

Verifier l'etat du cluster k3s :

```bash
kubectl get nodes
```

Sortie attendu : 

```bash
NAME   STATUS   ROLES                  AGE   VERSION
vm2    Ready    control-plane,master   31m   v1.32.3+k3s1
vm3    Ready    <none>                 30m   v1.32.3+k3s1
```

### 5. Gestion du cluster kubernetes depuis sa machine 

Pour gerer le cluster k3s depuis sa machine, il faut recuperer sur le node controleur `VM2`, le fichier `kubeconfig` localisé à l'emplacement *`/etc/rancher/k3s/k3s.yaml`* contenant toutes les informations nécessaires à `kubectl` et le copier sur *`$HOME/.kube/config`*.

Dans le fichier *`$HOME/.kube/config`*, remplaces *`server: https://127.0.0.1:6443`* par *`server: https://192.168.56.12:6443`*


Verifier kubectl configuration depuis son terminal:

```bash
kubectl cluster-info
```

Sortie attendu : 

```bash
Kubernetes control plane is running at https://192.168.56.12:6443
CoreDNS is running at https://192.168.56.12:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://192.168.56.12:6443/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

```

Lister tous les nœuds membres du cluster Kubernetes depuis sa machine :

```bash
kubectl get nodes
```
---

## 📚 Pour aller plus loin

- [Documentation Kubernetes](https://www.docker.com/)
- [Documentation K3S](https://k3s.io/)
- [Retour en arrière](../README.md)



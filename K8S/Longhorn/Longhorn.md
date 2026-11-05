Longhorn provides a open source solution for `storageClass` solution that allows the user to monitor, manage, backup and restore a kubernetes cluster data. Longhorn allows the storage of the backed up data inside an S3 object storage. We could use persistent values outside the cluster itself for all the nodes and pods to access such as a SAN, NAS or NFS server, however using NFS creates a dependency for the cluster. If the data is stored in the cluster deployments are faster and solutions for these are Rancher Longhorn, OpenEBS and Rook Ceph. 

## Installation
Longhorn requires some kernel modules that need to be enabled and packages to be installed. We can use the `longhornctl` command line tool to install the requirements:
```bash
curl -fsSL -o longhornctl https://github.com/longhorn/cli/releases/download/v1.13.0/longhornctl-linux-amd64
chmod +x longhornctl
sudo mv /usr/local/bin/longhornctl
```

We can check the installation requirements with the following command:
```bash
longhornctl check preflight
```

If the check returned errors we can run and check each of them one by one. The following steps are:
1. `NFSv4 Client`: We can check and install the NFSv4 if the kernel supported it by running the following commands:
```bash
cat /boot/config-$(uname -r) | grep 'CONIF_NFS_V4*'
apt install nfs-common
```
2. `Cryptsetup`:
```bash
apt install cryptsetup
```
3. `open-iscsi`:
```bash
apt install open-iscsi
modprobe iscsi_tcp
```
```


We can install the longhorn requirements by running the following command:
```bash
longhornctl --kubeconfig ~/.kube/config --image longhornio/longhorn-cli:v1.13.0 install preflight
```

We can install longhorn through the Helm package manager by running the following commands:
```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.13.0
```

##
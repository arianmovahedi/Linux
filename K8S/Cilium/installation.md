# Cilium
Cilium is a CNCF graduated CNI plugin for Kubernetes which provide networking, observability with hubble CLI or UI and network policy and filtering. Cilium is based on eBPF.

To install Cilium we must use the following command to firstly install the CLI tool to install Cilium:
```bash
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
```

If we are working on a cluster that had a CNI before we may need extra steps to migrate to Cilium CNI. We can check the installed Cilium CLI version with the following command:
```bash
cilium version --client
```

We need to install the CNI based on the latest version defined in the documentation with the following command:
```bash
cilium install 1.21.0
```

We can pass the cluster we want to install if our and the clusters subnet by using `--context` and more.

We can check the Pod CIDRs using the following command:
```bash
kubectl cluster-info dump | grep -E 'cluster-cidr|allocate-node-cidrs'
```

We can check the state of deployment using the following command:
```bash
cilium status --wait
```

Cilium creates its pods in the `kube-system` namespace as daemon sets.

We can install the Cilium on the cluster after initiating it with the `kubeadm init` command or after adding as many cluster nodes we want to it with the same `cilium install` command.

We can alo use Helm to deploy the cluster.


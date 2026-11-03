# Network Policies
We can use network policies to limit network access between the services. Cilium provides the network policy resource and provides a network observability with Hubble. We can check if there is any `ciliumnetworkpolicies` with the following command:
```bash
kubectl get ciliumnetworkpolicies -A
```

Or use the `cnp` instead of the full resource object name. We can use the Network Policies to allow connection if the Pod has an specific label. In the Cilium network policy we must first specify the `spec.endpointSelector{}` which specifies resources should this Network Policy should apply. The network policy here is `igress` meaning the resource we are going to assign the network policy to will receive the incoming network request that have the labels we specify in the `spec.ingress[].fromEndpoints[].matchLabels[]`. So any request that comes to this port from any pod with the labels we define is accepted.

We can also add rules that apply to the layer 7 of a network. We need to add a `spec.ingress[].toPorts[].rules.http[]` to add a `method` and a `path` that we want to allow. We tell it what HTTP method is allowed on which path and the rest is dropped.
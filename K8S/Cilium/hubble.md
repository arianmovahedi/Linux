# Hubble CLI
Hubble is the observability platform for Cilium and has a CLI and UI component. Hubble API operators within the scope of the individual node on which the Cilium agent runs and confines the network insights to the traffic observed by the local Ciliu, agent.

We can deploy a Hubble Relay network to observe the whole cluster. We need to enable hubble using Cilium.
```bash
cilium hubble enable
kubectl get -n kube-system pods hubble-relay-*
```

We then need to install Hubble CLI tool with the following command:
```bash
hubble status
```

Now we need to port forward to be able to access it.
```bash
cilium hubble port-forward &
```

Now we can use the hubble CLI to monitor the network. We can see the hubble connected nodes using the following command:
```bash
hubble list nodes
```

We can now use the `hubble observe` to check the connections and traffic flows. 
```bash
hubble observe -f
```

We can check the connection for a specific Pod and protocol like this:
```bash
hubble observer --pod pod-name --protocol http --verdit dropped
```

We can use other filter such as port and more with the hubble CLI.

# Hubble UI
Hubble provides a web UI for the observability platform and we need to enable it just like Hubble itself. We can do so with the following command:
```bash
cilium hubble enable --ui
```

And to use it we can use the `cilium hubble ui` if we can access a browser on our server machine. It is opened on the port 12000 by default but we can specify another port using the `--port-forward` option:
```bash
cilium hubble ui --port-forward 12001
```

If we are connected to the server through SSH we can port forward using the following SSH command so that we can expose the Hubble UI to us without putting it behind a web server. This sends traffic of the port 12000 to the machine with the SSH connections port 8090.
```bash
ssh -L 8090:localhost:12000 user@server
```

Now we can access the Hubble UI using the `http://localhost:8090` on the machine that has started the SSH connection.

We can check and send the traffic through the HAProxy to a URL in which it leads back to the IP of the Ingress set for the Hubble UI.
```bash
kubectl -n kube-system get svc | grep hubble
```

The HAProxy configuration of frontend and backend looks something like this:
```conf

```

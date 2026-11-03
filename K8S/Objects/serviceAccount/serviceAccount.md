# ServiceAccount
A ServiceAccount is a type of non-human account that in kubernetes provides distinct identity in a kubernetes cluster. Pods, system components, and entities inside and outside the cluster can use a specific ServiceAccount's credential to identify as the ServiceAccount. The identity is useful in various situtations, including authenticating to the API Server or implementing identity based security policies.

Each ServiceAccount is bound to a namespace and each namespace gets a `default` ServiceAccount upon creation. This default ServiceAccount has only the default API discovery permissions that k8s grants to all authenticated principals.

If you deploy a Pod in a namespace, and you don't manually assign a ServiceAccount to the Pod, Kubernetes assigns the default ServiceAccount for that namespace to the Pod.

## Use Cases
The first use case is the need to communicate with the API server, for things such as granting access to sensitive information stored in Secrets or granting cross-namespace access, such as allowing a Pod in a namespace to read, list and watch for Lease objects in the kube-node-lease namespace.

Some other use cases are Pod s requirement to communicate with external services. Authenticating to a private image registry using `imagePullSecret`. An external servie needs to communicate ith the K8s API Server. For example authenticating to the cluster as part of the CI/CD pipeline.

In order to use ServiceAccounts we need to take the following steps:
1. Create a ServiceAccount
2. Grant permissions to the ServiceAccount object using an authorization mechanism such as RBAC
3. Assign the ServiceAccount object to Pods during Pod creation. If we are going to use it in a external service we need to retrieve the ServiceAccounts token and use it instead of the service itself.
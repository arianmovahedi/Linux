# Automated Placement
Scheduler assigns pods to nodes that match the resource requests. Scheduler picks the best node to create, scale or move the pods to based on the runtime dependencies, resource requirements and guiding policies of high availability. Scheduler makes sure that the sum of the container resources requested for a pod is less than the available allocatable node capacity. Capacity of a node can be calculated like this:
```text
Allocatable [capacity for application pods] = Node Capacity [Available capacity on the node] - Kube Reserver [Kuberenetes daemons like kubelet and container runtime] - System Reserved [Operating system daemons like sshd, udev] - Eviction Thresholds [Reserved memory to prevent system OOMs]
```

It is important for the nodes to declare the container resource demands (`requests` and `limits`). When a pod is created it is picked up by the scheduler alongside the config of all available bide and is ran against a filtering policies at the first stage and then a set of feasible nodes remain. In the second stage the scheduler runs a set of functions to score the remaining feasible nodes and order them by weight and in the last stage scheduler will notify the API Server of the assignment decision.

We can assign labels to our nodes and use the labels on the nodes and in the Pod declaration define a set of labels that we want the node that is allocated to our pod to have. We can use the `spec.nodeSelector` and define a map of key value pairs. We can see an example of it in this [manifest](K8S/manifests/node-selector.yml)

Alongside user defined labels we can use other labels defined by Kubernetes and other plugins as well. For example we can use the `kuberentes.io/hostname` key and define the exact machine hostname. We can use other things such as OS, CPU architecture and so on.

## Node Affinity
Node affinity allow user to define the requirements with multiple `required` rules and a weighted `prefered` rule. The `required` rules must be met for a pod to be scheduled to a node whereas preferred rules only imply preference. With the `NodeAffinity` we can use operators such as `In`, `NotIn`,`Exist`,`DoesNotExist`,`Gt`,`Lt`. We can see an example of `nodeAffinity` in this [manifest](K8S/manfisets/node-affinity.yml).

## Pod Affinity and Anti-Affinity
Unlike node affinity that works at node granularity and is only to pick the node, Pod affinity can express rules at various topology levels base on the Pods already running on a node. When working with `podAffinity` and `podAntiAffinity` we define a `topologyKey`. Some `topologyKey`s are:
- kuberentes.io/zone
- kubernetes.io/hostname
- kuberentes.io/region

These values will be paired with the labels meaning they will be scheduled in the same node, zone or region. For example if the `labelSelector`s `matchLabels` has a `app: web` paired with a `topologyKey: kubernetes.io/zone` our pod will be scheduled on a node that has a node with the `app: web` label in its zone or if the topology is set as `hostname` it will be set in the same node that has a pod with the label `app: web` scheduled on it.
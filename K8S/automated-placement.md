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

These values will be paired with the labels meaning they will be scheduled in the same node, zone or region. For example if the `labelSelector`s `matchLabels` has a `app: web` paired with a `topologyKey: kubernetes.io/zone` our pod will be scheduled on a node that has a node with the `app: web` label in its zone or if the topology is set as `hostname` it will be set in the same node that has a pod with the label `app: web` scheduled on it. We can use self defined labels and be used in the `topologyKey` indicating whether we want out pod to be scheduled on a node with that label and if so what other pod labels should match.

Similat to `nodeAffinity` there are hard and soft requirements for Pod affinity and anti-affinity called `requiredDuringSchedulingIgnoredDuringExecution` and `preferredDuringSchedulingIgnoredDuringExecution`.

We can stop the pods from being in the same vecinity using the `podAntiAffinity` but we can also use other methods instead.

## Topology Spread Constraints
Topology spread constraints give you more fine-grained control to evenly distribute Pods on your cluster and achieve better cluster utilization or high availability of applications. Topology Spread Constraint allow you to tolerate some degree of uneven Pod distribution when the cluster is running out of resources since we can achieve this by using `podAntiAffinity` to tell the pods shouldn't be scheduled on the node where the same pod exists but there are limitations in this method that would make rolling updates a problem. We can use the `spec.topologySpreadConstraints` and use the `maxSkew` to define the maximum degree to which Pods can be unevenly distributed in a `topology`. The topology matters since we must define a `topologyKey` here as well. 

## Taints and Tolerations
Taints and tolerations allow the node to control which Pod should or should not be scheduled on them. A `taint` is a characteristic of a Node and when it is present, it prevents Pods from scheduling onto the node unless the Pod has tolerations fo that taint. A taint is added to a node by using the `kubectl tait` command. A taint if present can make a node unschedulable and if the Pod has the same taint it can be tolerated to be scheduled on that node. For example we can add the following taint to a node:
```bash
kubectl taint nodes control-plane-node node-role.kubernetes.io/control-plane="true":NoSchedule
```

We can also add this taint with a `Node` object kind. There are hard taints that prevent scheduling on a node (effect=NoSchedule), soft taints that try to avoid scheduling on a node (effect=PreferNoSchedule), and taints that can evict already-running Pods from a node (effect=NoExecute). Taints and tolerations allow for complex use cases like having dedicated nodes for an exclusive set of Pods, or force eviction of Pods from problematic nodes by tainting those nodes.

The scheduler will not make changes to the already scheduled pods even if our cluster is dynamic and constantly changing but we can use kubernetes `descheduler` that is a job that runs and is a optional feature to tidy up and defragment a cluster by rescheduling pods. The descheduler comes with some predefined policies that can be enabled and tuned or disabled.

The following are all the directives we can use to place our pods in the cluster:
- `nodeName`: This is not a best practice to do
- `nodeSelector`: A label map in which the node should have all of them to be eligible.
- `nodeAffinity`
- `Taints and Tolerations`: These allow the node to control which pods should or shouldn't be scheduled on them. Pods that don't have tolerations for the node taint will be rejected or evicted from the node.
- `podAffinity/podAntiAffinity`: These rules allow scheduling based on Pod's dependencies to other Pod rather than the nodes.
- `topologySpreadConstraints`: To use these platform administrators have to label nodes and provide topology information such as regions, zones or other user defined domains.
- Tunning or Providing a custom scheduler: We can tune the scheduler by changing it's config file to change the behavior of it's filtering stages with extension points and plugins. We can also write a custom scheduler with the help of the scheduler extenderprocess.
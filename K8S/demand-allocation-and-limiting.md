Following are some good principles to adhere to.
# Predictable demands
The resource requirements and the Runtime requirements should be defined. This allow kubernetes to schedule the Pods more efficiently since it can know the demand of each process in advance. One of the most important runtime requirements is storage and capacity planning is important and the data may need to survive after the pods are lost.

We can see the dependency to a `PersistentVolume` in the following [script](K8S/manifests/dependency-on-PersistentVolume.yml).

The scheduler will evaluate the kind of the volume the Pod requires which will affect where the pod is scheduled. Another dependency that is of runtime nature is exposing a container port to the host system using the `hostPort` directive that reserves a port on all nodes for that resource and it shouldn't clash with any other port that was reserved before.

Another runtime dependency is `ConfigMaps` which the kubernetes go to method to define configurations for our objects. If not all the expected ConfigMaps are created the Pods will be created but will not start. `Secrets` will have the same dependency as well. We can see a ConfigMap dependency in this [script](K8S/manifests/dependency-on-ConfigMap.yml).

Some dependency limit where the pod is scheduled and some may prevent the pod from starting up.

# Limits and Requests
When working with system resources such as CPU and RAM you have to specify the minumum amount of resources needed called `request` and the maximum amount it can grow up to known as `limits`. This is a concept similar to Java's `-Xmx` and `Xms` command line options.

The `requests` amounts is used when placing the pod to the node and it counts up all the containers resource and schedule the pod to a node. We can se the requests and limits in this [script](K8S/manifests/resource-limits.yml).

The following are the list of items we can define in the `limits` and `request` section of `resource` of a container:
|Type|Description|
|:---:|:---:|
|`memory`|The amount of heap memory allocated also including the `emptyDir` volume as well if `medium: Memory` is used in its definition is used.|
|`cpu`|It is better to set the `requests` but not the `limits` for this resource.|
|`ephemeral-storge`|This the on node filesystem storage dedicated for the log, writable container layers and the `emptyDir` that doesn't have the `medium: Memory` used for it.|
|`hugepage-<size>`|Huge pages are large, continous pre-allocated pages of memory that can be mounted as volumes. Depending on Kuberenetes node configuration several predefined sizes of huge pages are available like 2MB and 1GB pages. We can request 2 huge pages of size 1GB with the following syntax: `hugepage-1Gi: 2Gi`|

Based on whether we have set the `requests` and `limits` kubernetes handle the pods differently when the node runs out of resources. The approaches (called QoS or Quality of Service) are:
- Best-Effort: These pods have neither set for them and are considered lowest priority and is most likely killed first
- Burstable: Pods that the values in the `limits` and `requests` are not equal and the `limits` are set as larger and if no Best-Effort pods are killed these are killed in case of a resource shortage
- Guaranteed: These have the same values set in their `limits` and `requests` and have the highest priority and avoids OOM (Out of Memory) triggered evictions.

It is a best practice to use `limits` and `requests` for memory but only `requests` for CPU.

# Pod Priority
We can set the Pod priority to indicate the relative importance of a pod, affecting the order pods are scheduled. For this we need to define a `PritoriyClass` kind which has the `apiVersion` of `scheduling.k8s.io/v1`. We name the `PriorityClass` with its `metadata.name` and use it in the pods `spec.pritorityClassName` directive. We can see an example of that in this [manifest](K8S/manifests/priority-class.yml)
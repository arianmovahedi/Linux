# PodDistributionBudget
These object can be used to limit the number of concurrent distributions. This is used to create a definite high availability for an application that is handled by controllers like `Deployments`,`ReplicaSets`,`ReplicationController` or `StatefulSet`. We need to use the `.spec.selector` that was used in the controller inside the `PodDistributionBudget` as well. We can use either the `maxUnavailable` or `minAvailable`. We can see the same work around using each:

|Requirement|`maxUnavailable`|`minAvailable`|
|:---:|:---:|:---:|
|Don't reduce serving capacity by more than 10 percent|`minAvailable: 90%`|`maxUnavailable: 10%`|
|do not terminate this application without telling me|`maxUnavailable: 0`|`minAvailable: 100%`|
|Job needs to complete in case of voluntray disruption|-|-|

The `PodDistributionBudget` has three fields in its `.spec`:
- `.spec.selector`: to specify the set of Pods to which this applies and an empty selector `selector: {}` matches every pod in the namespace
- `.spec.minAvailable`: Number of pods from that set that must still be available after the eviction, even in the absence of the eviceted pod.
- `.spec.maxUnavailable`: pods from that set that can be unavailable after the eviction.

Only one of the `.spec.maxUnavailable` and `.spec.minAvailable` can be used in a single `PodDistributionBudget`. For example: With a `minAvailable` of 5, evictions are allowed as long as they leave behind 5 or more healthy pods among those selected by the PodDisruptionBudget's selector.

If you set maxUnavailable to 0% or 0, or you set minAvailable to 100% or the number of replicas, you are requiring zero voluntary evictions. When you set zero voluntary evictions for a workload object such as ReplicaSet, then you cannot successfully drain a Node running one of those Pods.
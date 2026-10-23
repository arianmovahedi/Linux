# PriorityClass
We can define `priorityClass` objects that can be used in order to set the scheduling order when multiple nodes are planned to be scheduled on a node. This type of object can be listed inside the `priorityClassList` and defined all together inside the `items` directive. We can define the `preemptionPolicy` inside the object or inside the `spec.preemptPolicy` of the Pod object. The following is a `priorityClass` object we can deploy in our cluster using the `kubectl create -f ./priorityClass.yml`:
```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: low-priority
  namespace: test
  labels:
    priority: low
value: -100 # can be negative
description: Lowest priority in the test namespace
globalDefault: true
```

The values for the `preemptionPolicy` are:
- `Never`: means that pod never preempts other pods with lower priority.
- `PreemptLowerPriority` means that pod can preempt other pods with lower priority.
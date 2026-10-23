# PriorityClassList
The `PriorityClassList` is an object from the `scheduling.k8s.io` family and contains a YAML list object holding multiple `PriorityClass` objects. These objects have all the directives set in the `PriorityClass` object type. An example of this object is shown below:
```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClassList
metadata:
  name: test-namespace-priorities
  labels:
    priority: class
items:
  - apiVersion: scheduling.k8s.io/v1
    kind: PriorityClass
    metadata:
      name: lowest
      labels:
        namespace: test
        type: priority
    globalDefault: true
    value: -100
    description: Lowest priority in the test environment
    preemptionPolicy: PreemptLowerPriority

  - apiVersion: scheduling.k8s.io/v1
    kind: PriorityClass
    metadata:
      name: low
      labels:
        namespace: test
        type: priority
    globalDefault: false
    value: 0
    description: Second lowest priority in the test environment
    preemptionPolicy: Never
```
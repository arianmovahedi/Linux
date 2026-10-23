# Declarative Deployments
For the deployments to work we require the containers to provide good `Health check` endpoints and handle the `SIGTERM` in their logic. If these two conditions are satisfied we can deploy applications, update and remove them very easily with a `Deployment` object.

Deployments are the declarative way of updating an application in kuberentes. The deployment creates a ReplicaSet that supports set-based label selectors and allows the update to be either a `RollingUpdate` or `Recreate` type which is defined in the `spec.strategy.type` directive. We can see a rolling update example in the [manifest](K8S/manifests/rolling-update.yml).

`RollingUpdate` ensures there is no downtime during the update process. Behind the scenes the Deployment creates new ReplicaSets and replaces old containers with new ones. Use Deployments since they allow you to control the range of available and excess pods through `maxSurge` and `maxUnavailable` directives.

We can use the `minReadySec` directive to specify the duration the readiness probe of a pod need to succeed until the pod is considered available in a rollout. Increasing this value allow us a bigger window incase we would need to pause or stop the rollout.

The following are the benifits of using the Deployment for an update:
1. They are entirely managed by the kubernetes itself on server side.
2. The update process is wholly recorded and versioned with options to pause, continue and rollback.

The `RollingUpdate` type is useful for zero downtime update but in case of a backward incompatible update it will cause problems for the consumers. In this case we use the following type:
```yaml
type: Recreate
```

# Blue-Green deployment
You maintain two separate environments—or, in Kubernetes, typically two Deployments:
- Blue: The current production version, such as v1.0.
- Green: The new version, such as v1.1.

How it works
Step 1: Blue handles production traffic.
```text
Users → Service → Blue pods (v1.0)
```

Step 2: Deploy Green alongside Blue.
Green is running, but the production Service does not select it yet. You can test it through a separate preview Service.

```text
Users → Production Service → Blue pods (v1.0)
Testers → Preview Service  → Green pods (v1.1)
```

Step 3: Once Green is ready, switch the production Service to it.
```text
Users → Production Service → Green pods (v1.1)

                            Blue pods (v1.0): kept for rollback
```

Step 4: Remove Blue when you no longer need it for rollback.

## Kubernetes implementation
Give the Pods labels that identify their environment:
```yaml
# Blue Pod labels
labels:
  app: customer
  track: blue
```
```yaml
# Green Pod labels
labels:
  app: customer
  track: green
```
Initially, the production Service selects Blue:
```yaml
spec:
  selector:
    app: customer
    track: blue
```

Switch traffic by updating the selector:
```bash
kubectl patch service customer \
  -p '{"spec":{"selector":{"track":"green"}}}'
```

The existing app: customer selector remains in place.
If problems arise, switch back:

```bash
kubectl patch service customer \
  -p '{"spec":{"selector":{"track":"blue"}}}'
```

Important: This is a logical traffic switch, not a guarantee that every connection moves instantly. Endpoint updates take time to propagate, and existing connections or in-flight requests may still reach Blue.

# Canary deployment
A Canary deployment exposes the new version to a small share of real production traffic before releasing it broadly.
Unlike Blue-Green, both versions intentionally serve production traffic during the evaluation period.

How it works
Step 1: The stable version handles all traffic.
```text
Users → Service → Stable pods (v1.0)
```
Step 2: Deploy a small number of Canary pods.
For example, run nine stable Pods and one Canary Pod:
```text
                  ┌→ Stable: 9 pods (v1.0) → most traffic
Users → Service ──┤
                  └→ Canary: 1 pod  (v1.1) → some traffic
```

Step 3: Monitor the Canary.
Compare the new version against the stable version using:
- Error rates
- Response times
- Resource usage
- Application-specific success metrics

Step 4: Expand or roll back.
If the Canary performs well, increase the new version’s replicas and reduce the old version’s replicas.

```text
Small exposure → Larger exposure → Full rollout
```

If problems appear, scale the Canary down and keep the stable version serving traffic.

## Kubernetes implementation
Both Deployments share an application label but have different version labels:
```yaml
# Stable Pod labels
labels:
  app: customer
  version: v1.0
```
```yaml
# Canary Pod labels
labels:
  app: customer
  version: v1.1
The Service deliberately selects both versions by matching only their shared label:
yaml
spec:
  selector:
    app: customer
```

For an initial Canary:
```bash
kubectl scale deployment customer-stable --replicas=9
kubectl scale deployment customer-canary --replicas=1
```

Important: Nine stable Pods and one Canary Pod do not guarantee an exact 90%/10% request split. Connection reuse, session affinity, and traffic patterns can affect the distribution.
For explicit traffic weights or routing particular users to the Canary, use a traffic-routing layer that supports those features, such as a suitable ingress controller, Gateway implementation, or service mesh.

When managing these Pods through Deployments, scale the Deployments, rather than directly modifying their managed ReplicaSets. Also give the two Deployments distinct selectors so they do not overlap.
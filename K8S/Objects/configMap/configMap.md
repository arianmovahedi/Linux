# ConfigMap
ConfigMaps are objects used to store non-credential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

A ConfigMap allows us to decouple environment specific configurations from container images. ConfigMaps do not provide any sort of privacy or encryption unlike secrets.

A ConfigMap is not designed to hold large chunks of data. The data stored in a ConfigMap cannot exceed 1 MiB and if we want to use something larger it is best to use an actual file mount.

A ConfigMap object has `data` and `binaryData` fields instead of the `spec` field. The values inside the `data` and `binaryData` can not overlap in terms of keys. The `data` field recieves keys with UTF-8 values while the `binaryData` recieves keys with base64 encoded data. We can also ass a `immutable` directive to the ConfigMap to make it immutable since the configs mounted from the ConfigMap are applied dynamically inside the relative Pod when changed. However the kubelet uses it's local cache for getting the current value of the ConfigMap. The type of cache is configurable using the `configMapAndSecretChangeDetectionStrategy` field in the `kubeletConfiguration` struct.

ConfigMaps are namespace bound and needs to be in the same namespace as the Pod it is being used in. 

## Using ConfigMaps
We can use ConfigMaps key-value data inside a Pod as a file. To do so we need to create ConfigMap and apply it in the Pod using the `.spec.volumes.configMap.name`. We can bring each of the items in a ConfigMap or its whole key-values in the mount. We can then use a `.spec.containers[].volumeMounts[].mountPath` to an unused directory name where you would like the ConfigMap to appear.

We can use ConfigMaps as environment variables in a Pod and we need tp use the `spec.containers[].env[].ValueFrom.configMapKeyRef` field to select the ENV individualy by the key or use the `.spec.containers[].envFrom[].configMapRef` for a full set of envs from the config. The envFrom field instructs Kubernetes to create environment variables from the sources nested within it. The inner configMapRef refers to a ConfigMap by its name and selects all its key-value pairs. Sometimes a Pod won't require access to all the values in a ConfigMap.

The immutable Secrets and ConfigMaps provide options to prevent changes to their data. The advantages are that is protects you from accidental or unwanted updates that could cause outages. This also improves the performance of you cluster by significantly reducing load on `kube-apiserver` by closing watches for ConfigMaps marked as immutable. Once a ConfigMap is marked as immutable, it is not possible to revert this change nor to mutate the contents of the `data` or the `binaryData` field.
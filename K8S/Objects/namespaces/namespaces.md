# Namepace
We can create a new namespace by creating its object and running the `kubectl create` command. The YAML manifest to create a `test` namespace can look like this:

`./namespaces.yml`
```yaml
apiVersion: v1
kind: namespace
metadata:
  name: test
```
```bash
kubectl create -f ./namespace.yml
```

We can delete the namespace by running the following command:
```bash
kubectl delete namespace test
```

We can add labels and annotations to the namespaces as well by the command line like:
```bash
kubectl label namespace test env=test
```

We can add `ResourceQuota`, `LimitRanges`, `Role`, `ServiceAccount`, `Role` and more for the namespace.
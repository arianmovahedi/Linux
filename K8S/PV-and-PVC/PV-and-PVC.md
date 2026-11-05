# PV and PVC
Containers and Pods are immutable meaning they do not write anything on the disk of the host they are on, these applications are called stateless application and do not need to store data. Any application that needs to have the state as before they were are called stateful applications. In kubernetes we use volumes to mount a persistent volume to the application filesystem where our application can write their data in this mounted volumes. 

The easiest is to write to the nodes hard drive that the Pod is spawned and scheduled on. This is called `hostPath` and we can add it to a `mountPath`. 
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: local-web
spec:
    replicas: 1
    selector:
        matchLabels:
            app: local-web
    template:
        metadata:
            labels:
                app: local-web
        spec:
            containers:
            - name: local-web
              image: nginx
              ports:
                - name: web
                  containerPort: 80
              volumeMounts:
                - name: local # name of the volume
                  mountPath: /usr/share/nginx/html # path in the container
            volumes:
            - name: local
              hostPath:
                path: /usr/share/nginx/html
```

`hostPath` represents a path on the node filesystem and every file on the nodes filesystem will be added to the container filesystem.

If any file is created in this directory by the Pod it will persist on the nodes filesystem.

Mounting a host path is only good for one node cluster and using local hard drive of the node makes it inaccessible to other nodes.

To achieve fault tolerance we need a shared storage outside the nodes iteself and we can do this by defining a PersistentVolume that tells how much persistent volume is available and how to access it using the `storageClass` type. We can use S3, NFS, ... . After creating the PV we need to create a PVC to give access to the Pod to use the PV. The PV connects to the data storage backend like NFS and the PVC allows the Pod to use the said backend though the PV. The following is a PV configured for the NFS server.
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
    name: nfs
spec:
    capacity: 
        storage: 500Mi
    accessModes:
        - ReadWriteMany
    storageClassName: nfs
    nfs: # Should be accessed through the NFS protocol
        server: 192.168.1.7
        path: "/srv/nfs/
```

We need to specify the capacity and we need to define the `accessMode` which tells Kubernetes how each Pod will interact with them. Some `storageClasses` will not support `ReadWriteMany` mode. PersistentVolumes are not bound to a namespace.
- `ReadWriteOnce`: The volume can be mounted as read-write by a single node and we can't access the same `PersistentVolume` from other nodes.
- `ReadWriteMany`:

We can access the created PVs using the following command:
```bash
kubectl get pv
```

The following is a PersistentVolumeClaim that will use the PersistentVolume that we created called `nfs`:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: nfs
spec:
    accessMode:
        - ReadWriteMany
    storageClassName: nfs
    resources:
        requests:
            storage: 100Mi
```

Once we deploy this K8s will look to check whether there is a `nfs` storageClass or PV that can satisfy these needs. We can then check the PV now using the `kubectl get pv` and check if the PVC is bound to it or not. The PVC asks for 100Mi while when attached to the PV it will have all the 500Mi that the PV offers. For the Pod we can have the following manifest for our Pod:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: nfs-web
spec:
    replicas: 1
    selector:
        matchLabels:
            app: nfs-web
    template:
        metadata:
            labels:
                app: nfs-web
        spec:
            containers:
            - name: nfs-web
              image: nginx
              ports:
              - name: web
                containerPort: 80
              volumeMounts:
                - name: nfs
                  mountPath: /usr/share/nginx/html
            volumes:
            - name: nfs
              persistentVolumeClaim:
                claimName: nfs
```

Now we can scale up our Pods since the data is bound to a shared storage outside the kubernetes cluster.

For storageClass providers such as longhorn we do not need to create PV first we can use the storage backend and name it in our `storageClassName` in the PVC resource and the backend is selected by the kubernetes and the PV is created using that provisioner.
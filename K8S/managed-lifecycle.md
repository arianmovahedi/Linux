# Managed Lifecycle
Containers listen and adapt to the events issued by the cluster and can't control their lifecycle. Whenever Kuberentes decides to shut down a container for any reason it sends a SIGTERM signal. If a container process has not shutdown after a SIGTERM singal it is shutdown forcefully by a SIGKILL signal. By default Kubernetes waits for 30 seconds before sending the SIGKILL. we can use the `spec.terminationGracePeriodSeconds` to set a different value.

## PostStart Hook
There are additional lifecycle hooks like the `preStop` and `postStop` hooks. These hooks are defined for each container in a Pod and are in the `spec.containers.lifecycle` section of each container. we can see an example of it in this [manifest](K8S/manifests/post-stop.yml).

The `postStart` is a blocking action meaning the container will not enter a ready state even if its main process is up and running until the `postStart` is passed. This can also be used to prevent a container from starting when the pod doesn't fulfill certain preconditions. The `postStart` and `preStop` hooks can use the `exec` and `httpGet` methods.

## PreStop Hook
The `preStop` hooks is a blocking call sent to a container before it is terminated. The `preStop` hook must complete before the SIGTERM call is made by the container runtime. If the `preStop` hook fails it will not prevent a deletions and it is simply an alternative to a SIGTERM signal for graceful application shutdown. We can see an implementation of the `preStop` hook in this [manifest](K8S/manifest/pre-stop.yml).

## Rewriting container entrypoint
Every container image defines a commnad that is executed by default when the container starts. We can use the container level `command` directive to provide a command and `args` to provide more arguments for a fine grain control. We can see an example in this [manifest](K8S/manifests/command.yml)
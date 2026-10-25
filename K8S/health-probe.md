# Health Probe
Health Probes are an automatic way for the application to tell Kubernetes that they are active and doing their job properly. Only checking the main process of a container will not do since the application process may be still active but the app can't serve due to a OOM error or a Deadlock. 

## Healt Check Probe
There are different types of health checks that Kubernetes does:
1. `Process Health Check`: The simplest check that kubelet constantly perform. If a container processs are not running, the container is restarted.
2. `Liveness Probe`: Used to detect issues like deadlock or logic errors, since this issue doesn't kill the process. These checks are also done with the kubelet. Just like the process health check on the event of this health check failure the container is restarted. The different kind of health checks are:
- `HTTP Probe`: Performs an HTTP GET request to the container IP address and expects a response code between 200 to 399
- `TCP Socket Probe`: Assumes a successful TCP connection
- `Exec Probe`: Executes an arbitrary command in the container's user and kernel namespace and expects a 0 exit code
- `gRPC Probe`: Leverages gRPC's intrinsic supporf for health checks.

Health check probke behavior can be influenced by the following parameters:

|Parameter|Description|
|:---:|:---:|
|`initialDelaySeconds`|Specifies the number of secinds to wait until the first liveness probe is checked|
|`periodSeconds`|The interval in seconds betwenn liveness probe checks|
|`timeoutSeconds`|The maximum time allowed for a probe check to return before it is considered to have failed|
|`failureThreshold`|Specifies how many times a probe check needs to fail before it is considered to have failed|

We can see an example of the HTTP liveness probe in this [manifest](K8S/manifests/liveness-probe.yml).

## Readiness Probe
This check is done first and it is what indicates that the container is ready to serve. The option are similar to health check probes meaning `httpGet`, `exec`, `grpc` and `socket`. If a readiness probe fails unlike the health check it will not restart the container, it will remove the container from the endpoint and it will not recieve any new traffic. Readiness probes are done reqularly just like the health check probes. We can check an example of a readiness probe in this [manifest](K8S/manifests/readiness-probe.yml).

Health checks are designed to recover from the failure while readiness checks are intended to buy time for your application and expect it to recover by itself.

There is also another probe available called `readinessGates` which we specify in the `spec` directive.

In case of applications that take a while to start up the liveness checks will cause the container to restart before the startup is finished. In order to stop this behavior we can use the `startup probes`. We can use long initial delays for readiness and long intervals for liveness probes but this is not optimal since these are applied for the post startup phase.

Startup probes are configured with the same format as liveness probes but allow for different values for the prob action and the timing parameters. The container is restarted if the startup probe is not successful. We can see an example of a statup probe in this [manifest](K8S/manifests/startup-probe.yml).
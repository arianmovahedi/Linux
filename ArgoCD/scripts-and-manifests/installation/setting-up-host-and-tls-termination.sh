#!/bin/bash
# The following script will set the URL and terminates the Argo CD internal TLS
kubectl -n argocd patch configmap argocd-cm \
    --type merge \
    -p '{"data":{"url":"https://argo.hudata.ir"}'


# The following --args patch will replace the whole flags. it is better to set it in the Helm chart
kubectl -n argocd patch configmap argocd-server \
    --type merge \
    -p '{ \
            "spec":{ \
                "template":{ \
                    "spec":{ \
                        "containers":[ \
                            { \
                                "name":"argocd-server", \
                                "args":["--insecure"] \
                            } \
                        ] \
                    ] \
                } \
            } \
        }'
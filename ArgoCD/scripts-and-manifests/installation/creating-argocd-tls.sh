#!/bin/bash
kubectl -n argocd create secret tls argo-tls \
    --cert=/path/to/fullchain.pem \
    --key=/path/to/privkey.pem

# creating the manifest with the base64 data
kubectl -n argocd create secret tls argo-tls \
    --cert=/path/to/fullchain.pem \
    --key=/path/to/privkey.pem \
    --dry-run=client \
    -o yaml > argo-tls.yml
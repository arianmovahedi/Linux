#!/bin/bash
kubectl -n argocd describe certificate argo-tls
kubectl -n argocd get challenges
kubectl -n get clusterissuer letsencrypt-prod
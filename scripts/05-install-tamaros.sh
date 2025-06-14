#!/bin/bash
# Install TamarOS

export KUBECONFIG=/tmp/rke2-kubeconfig

# Install TamarOS
kubectl apply -f https://raw.githubusercontent.com/abdulkarimss/TamarOS/main/deploy/kubernetes/quick-install.yaml

# Create Ingress
cat << INGRESS | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tamaros-ingress
  namespace: tamaros-system
spec:
  ingressClassName: nginx
  rules:
  - host: tamaros.apps.cluster.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: tamaros-console
            port:
              number: 80
INGRESS

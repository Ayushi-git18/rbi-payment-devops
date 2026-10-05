#!/bin/bash

set -e

NAMESPACE="payment-platform"

echo "Checking Kubernetes cluster..."

if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "Kubernetes cluster is not reachable."
  exit 1
fi

echo "Applying namespace..."
kubectl apply -f k8s/namespace.yaml

echo "Checking payment Secret..."

if ! kubectl get secret payment-secret -n "$NAMESPACE" >/dev/null 2>&1; then
  echo "ERROR: payment-secret does not exist."
  echo "Create it with:"
  echo ""
  echo "kubectl create secret generic payment-secret \\"
  echo "  --namespace payment-platform \\"
  echo "  --from-literal=SERVICE_TOKEN='your-token'"
  echo ""
  exit 1
fi

echo "Applying ConfigMap..."
kubectl apply -f k8s/configmap.yaml

echo "Applying ServiceAccount..."
kubectl apply -f k8s/serviceaccount.yaml

echo "Applying Processor..."
kubectl apply -f k8s/processor/deployment.yaml
kubectl apply -f k8s/processor/service.yaml

echo "Applying Gateway..."
kubectl apply -f k8s/gateway/deployment.yaml
kubectl apply -f k8s/gateway/service.yaml

echo "Applying NetworkPolicy..."
kubectl apply -f k8s/network-policy.yaml

echo "Waiting for Processor deployment..."
kubectl rollout status deployment/payment-processor \
  -n "$NAMESPACE" \
  --timeout=120s

echo "Waiting for Gateway deployment..."
kubectl rollout status deployment/payment-gateway \
  -n "$NAMESPACE" \
  --timeout=120s

echo ""
echo "Deployment completed successfully."
echo ""

echo "Pods:"
kubectl get pods -n "$NAMESPACE"

echo ""
echo "Services:"
kubectl get services -n "$NAMESPACE"#!/bin/bash

set -e

NAMESPACE="payment-platform"
CLUSTER_NAME="rbi-payment"

echo "Checking Kubernetes cluster..."

if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "Kubernetes cluster is not reachable."
  exit 1
fi

echo "Applying Kubernetes manifests..."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/serviceaccount.yaml
kubectl apply -f k8s/secret.example.yaml

kubectl apply -f k8s/processor/deployment.yaml
kubectl apply -f k8s/processor/service.yaml

kubectl apply -f k8s/gateway/deployment.yaml
kubectl apply -f k8s/gateway/service.yaml

kubectl apply -f k8s/network-policy.yaml

echo "Waiting for Processor deployment..."
kubectl rollout status deployment/payment-processor \
  -n "$NAMESPACE" \
  --timeout=120s

echo "Waiting for Gateway deployment..."
kubectl rollout status deployment/payment-gateway \
  -n "$NAMESPACE" \
  --timeout=120s

echo ""
echo "Deployment completed successfully."
echo ""
kubectl get pods -n "$NAMESPACE"
echo ""
kubectl get services -n "$NAMESPACE"

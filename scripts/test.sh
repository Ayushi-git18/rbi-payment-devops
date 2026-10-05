#!/bin/bash

set -e

NAMESPACE="payment-platform"

echo "Checking Kubernetes cluster..."

if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "ERROR: Kubernetes cluster is not reachable."
  exit 1
fi

echo "Checking namespace..."
kubectl get namespace "$NAMESPACE"

echo "Checking deployments..."
kubectl rollout status deployment/payment-processor \
  -n "$NAMESPACE" \
  --timeout=120s

kubectl rollout status deployment/payment-gateway \
  -n "$NAMESPACE" \
  --timeout=120s

echo ""
echo "Checking pods..."
kubectl get pods -n "$NAMESPACE"

echo ""
echo "Checking services..."
kubectl get services -n "$NAMESPACE"

echo ""
echo "Checking processor endpoints..."
kubectl get endpoints payment-processor -n "$NAMESPACE"

echo ""
echo "Checking payment Secret..."
kubectl get secret payment-secret -n "$NAMESPACE"

echo ""
echo "Checking NetworkPolicy..."
kubectl get networkpolicy -n "$NAMESPACE"

echo ""
echo "Checking PodDisruptionBudgets..."
kubectl get pdb -n "$NAMESPACE"

echo ""
echo "Kubernetes validation completed successfully."

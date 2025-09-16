#!/usr/bin/env bash
# cleanup-observability.sh
# Cleans up Kubernetes kube-prometheus-stack and Docker-based monitoring containers

set -euo pipefail

echo "=== 🧹 Cleaning up Kubernetes monitoring stack ==="

# 1. Uninstall Helm release if it exists
if helm status monitoring-stack -n monitoring >/dev/null 2>&1; then
  echo "Uninstalling Helm release 'monitoring-stack'..."
  helm uninstall monitoring-stack -n monitoring
else
  echo "No Helm release 'monitoring-stack' found in namespace 'monitoring'."
fi

# 2. Delete monitoring namespace if it exists
if kubectl get ns monitoring >/dev/null 2>&1; then
  echo "Deleting namespace 'monitoring'..."
  kubectl delete namespace monitoring
else
  echo "Namespace 'monitoring' not found."
fi

# 3. Delete Prometheus Operator CRDs (optional)
echo "Deleting Prometheus Operator CRDs..."
kubectl delete crd alertmanagers.monitoring.coreos.com \
  podmonitors.monitoring.coreos.com \
  probes.monitoring.coreos.com \
  prometheuses.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  thanosrulers.monitoring.coreos.com 2>/dev/null || true

# 4. Delete any lingering PVCs/PVs from monitoring
echo "Deleting lingering PVCs in 'monitoring' namespace (if any)..."
kubectl delete pvc --all -n monitoring 2>/dev/null || true

echo "=== 🐳 Cleaning up Docker-based monitoring stack ==="

# 5. Stop and remove Docker Compose stack if docker-compose.yml exists
if [ -f docker-compose.yml ]; then
  echo "Stopping Docker Compose stack..."
  docker compose down -v || docker-compose down -v
else
  echo "No docker-compose.yml found in current directory."
fi

# 6. Remove any standalone Prometheus/Grafana containers
echo "Removing standalone Prometheus/Grafana containers..."
docker ps -a --filter "ancestor=prom/prometheus" --format "{{.ID}}" | xargs -r docker rm -f
docker ps -a --filter "ancestor=grafana/grafana" --format "{{.ID}}" | xargs -r docker rm -f

# 7. Prune unused Docker resources (containers, networks, images, volumes)
echo "Pruning unused Docker resources..."
docker system prune -af --volumes

echo "✅ Cleanup complete. Cluster and Docker host are free of observability stack."

#!/usr/bin/env bash
# ============================================================
# Cleans up Kubernetes kube-prometheus-stack and
# Docker-based monitoring containers, volumes, and networks.
# Safe to run multiple times — skips steps if resources not found.
# Supports:
#   --dry-run   → Preview actions without executing
#   Confirmation prompt before destructive actions
# ============================================================

set -euo pipefail

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "=== 📝 DRY RUN MODE ENABLED ==="
  echo "Commands will be shown but not executed."
fi

run_cmd() {
  if $DRY_RUN; then
    echo "[DRY-RUN] $*"
  else
    eval "$@"
  fi
}

# --- Confirmation prompt ---
if ! $DRY_RUN; then
  echo "⚠️  This will remove Kubernetes monitoring stack and Docker-based monitoring containers."
  read -rp "Are you sure you want to proceed? (y/N): " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❌ Cleanup aborted."
    exit 0
  fi
fi

echo "=== 🧹 Cleaning up Kubernetes monitoring stack ==="

# 1. Uninstall Helm release if it exists
if helm status monitoring-stack -n monitoring >/dev/null 2>&1; then
  echo "Uninstalling Helm release 'monitoring-stack'..."
  run_cmd helm uninstall monitoring-stack -n monitoring
else
  echo "No Helm release 'monitoring-stack' found in namespace 'monitoring'."
fi

# 2. Delete monitoring namespace if it exists
if kubectl get ns monitoring >/dev/null 2>&1; then
  echo "Deleting namespace 'monitoring'..."
  run_cmd kubectl delete namespace monitoring
else
  echo "Namespace 'monitoring' not found."
fi

# 3. Delete Prometheus Operator CRDs (optional)
echo "Deleting Prometheus Operator CRDs..."
run_cmd kubectl delete crd alertmanagers.monitoring.coreos.com \
  podmonitors.monitoring.coreos.com \
  probes.monitoring.coreos.com \
  prometheuses.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  thanosrulers.monitoring.coreos.com 2

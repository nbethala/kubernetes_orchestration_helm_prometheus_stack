# 🛠 Observability Troubleshooting Guide

This guide documents the issues encountered while setting up Prometheus, Grafana, and Alertmanager for `my-node-webapp` in Kubernetes, along with root causes and resolutions.

---

## 1️⃣ `no matches for kind "PrometheusRule"` Error

**Symptom:**
```bash
error: resource mapping not found for name: "sre-golden-signal-alerts" namespace: "monitoring" from "sre-alerts.yaml": no matches for kind "PrometheusRule" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first

Root Cause:

The PrometheusRule resource is a Custom Resource Definition (CRD) provided by the Prometheus Operator.

The CRD was not installed because the Operator wasn’t deployed yet.

Fix:

Install Prometheus via the kube-prometheus-stack Helm chart, which includes the Operator and CRDs:
helm install monitoring-stack prometheus-community/kube-prometheus-stack -n monitoring

Rule Not Showing in Prometheus UI
Symptom:

kubectl apply succeeded for sre-alerts.yaml.

No sre-golden-signals group visible in Prometheus Status → Rules.

Root Cause:

The Prometheus CR’s ruleSelector only loads rules with a matching label:

ruleSelector:
  matchLabels:
    release: monitoring-stack

The PrometheusRule was missing the release=monitoring-stack label.

Fix:

Add the label to the YAML:

metadata:
  labels:
    release: monitoring-stack


Still No Rules After Label Fix
Symptom:

Label matched, Operator running, but rules still not visible.

Root Cause:

Looked at the wrong Prometheus instance (prometheus-server from a different chart) instead of the Operator-managed prometheus-operated.

Fix:

Port-forward the correct service:

kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

Rules in ConfigMap but Not in UI
Symptom:

sre-golden-signal-alerts present in the generated ConfigMap:

kubectl get configmap prometheus-monitoring-stack-kube-prom-prometheus-rulefiles-0 -n monitoring -o yaml
Still not visible in Prometheus UI.

Root Cause:

Prometheus only loads rules at startup (Admin API reload disabled by default).

The pod was running before the rule was added.

Fix:

Restart Prometheus pods:
kubectl delete pod -n monitoring -l app.kubernetes.io/name=prometheus

Validating Alerts
Steps Taken:

Added /fail endpoint returning HTTP 500 to trigger HighErrorRate.

Added artificial delay in handler to trigger HighRequestLatency.

Used hey to sustain load for >5 minutes (matching for: duration in rules).

Verified alerts in:

Prometheus UI → Alerts

Alertmanager UI

Lessons Learned
Label Matching Matters — ruleSelector and ServiceMonitor selectors must match exactly.

Operator vs Standalone — Always confirm you’re looking at the Operator-managed Prometheus (prometheus-operated).

Rules Load on Restart — Without Admin API reload, restart Prometheus after adding rules.

Metrics Must Exist — No data = no alert; generate traffic for validation.

ConfigMap is the Source of Truth — If it’s not in the aggregated rulefiles ConfigMap, Prometheus will never see it.




# 📊 Observability — Kubernetes + Prometheus + Grafana

This project implements a **production‑grade observability stack** for `my-node-webapp` running in Kubernetes, using the **kube-prometheus-stack** Helm chart.

## 🚀 Highlights
- **Prometheus Operator** for Kubernetes‑native monitoring
- **Grafana** dashboards for real‑time visualization
- **SRE Golden‑Signal Alerts** (latency, traffic, errors, saturation)
- **ServiceMonitor** for automatic target discovery
- **Alertmanager** for alert routing

## 🛠 Architecture
- **Prometheus** scrapes metrics from `my-node-webapp` via `/metrics`
- **Grafana** visualizes metrics with custom dashboards
- **PrometheusRule** defines golden‑signal alerts
- **Alertmanager** receives and displays alerts

## Architecture diagram 

flowchart LR
  subgraph K8s[Kubernetes cluster]
    APP[my-node-webapp\n/metrics]
    SVC[(Service: my-node-webapp\nport: http/3001)]
  end

  SM[ServiceMonitor\n(release=monitoring-stack)]
  PO[Prometheus Operator]
  PR[Prometheus\n(operated)]
  RULE[PrometheusRule\n(golden signals)]
  GRAF[Grafana]
  AM[Alertmanager]

  APP --> SVC
  SVC -. discovery .-> SM
  SM --> PO
  RULE --> PO
  PO -->|generates rulefiles ConfigMap| PR
  PR -->|scrapes metrics| APP
  PR --> GRAF
  PR --> AM


Observability Flow — Kubernetes + Prometheus + Grafana

How to read it:

my-node-webapp (inside Kubernetes) exposes /metrics.

ServiceMonitor (CRD) discovers the service automatically.

Prometheus scrapes the metrics.

PrometheusRule defines golden‑signal alerts.

Grafana visualizes the metrics.

Alertmanager receives and routes alerts.


## ⚡ Quick Start
```bash
# Install kube-prometheus-stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring-stack prometheus-community/kube-prometheus-stack -n monitoring

# Deploy ServiceMonitor & Alerts
kubectl apply -f my-node-webapp-servicemonitor.yaml
kubectl apply -f sre-alerts.yaml

## Validation
Prometheus UI → http://localhost:9090 (port‑forward prometheus-operated)

Grafana UI → http://localhost:3000 (port‑forward monitoring-stack-grafana)

Alertmanager UI → http://localhost:9093 (port‑forward alertmanager-operated)

## Outcome
End‑to‑end observability with:

Automated metric scraping

Golden‑signal dashboards

Real‑time alerting


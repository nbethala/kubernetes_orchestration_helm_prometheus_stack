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


<img width="3840" height="773" alt="observability-architecture-2" src="https://github.com/user-attachments/assets/78cc1c24-e6bf-427d-ae65-5cc53908e6eb" />


## How to read this diagram

1. **my‑node‑webapp** – Runs inside Kubernetes and exposes metrics at `/metrics`.
2. **ServiceMonitor** *(Custom Resource Definition)* – Automatically discovers the service endpoint.
3. **Prometheus** – Periodically scrapes those metrics for storage and analysis.
4. **PrometheusRule** – Defines alerting rules based on golden‑signal indicators.
5. **Grafana** – Queries Prometheus and visualizes the collected metrics in dashboards.
6. **Alertmanager** – Receives alerts from Prometheus and routes them to configured channels (e.g., email, Slack, PagerDuty).


## ⚡ Quick Start

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

Repository Structure

```plaintext
.
├── LICENSE                               # Open-source license for the project
├── README.md                             # Main project overview and usage instructions
├── cleanup-script.md                     # Markdown doc describing cleanup steps or scripts
├── docs/                                  # Documentation folder (designs, guides, references)
├── k8s/                                   # Kubernetes manifests and related configs
│   ├── .gitkeep                           # Placeholder to keep folder in version control
│   ├── app_deploy.yaml                    # Deployment manifest for the application
│   ├── docker-compose.yaml                # Docker Compose setup (local dev/testing)
│   ├── my-node-webapp.yaml                # K8s manifest for my-node-webapp service/deployment
│   ├── prometheus.yaml                    # Prometheus deployment/service configuration
│   ├── prometheus.yml                     # Prometheus scrape config file
│   └── sre-alerts.yaml                    # PrometheusRule for SRE golden-signal alerts
├── observability-setup.md                 # Full procedure for setting up observability stack
├── observability-troubleshooting.md       # Troubleshooting guide for observability issues
├── observability.md                       # General observability notes or summary
├── scripts/                               # Utility scripts for automation/maintenance
│   └── cleanup-observability.sh           # Script to remove observability components
├── src/                                   # Application source code
│   ├── Dockerfile                         # Docker build instructions for the app
│   ├── index.js                           # Main Node.js application entry point
│   ├── node_modules/                      # Installed Node.js dependencies
│   ├── package-lock.json                  # Locked dependency versions for reproducible builds
│   └── package.json                       # Project metadata and dependencies
└── troubleshooting/                       # Test and recovery scenario documentation
    ├── Pod-Failure-Simulation.md          # Steps to simulate pod failures
    ├── failure-recovery.md                 # Recovery procedures for failures
    ├── load-balancing-test.md              # Load balancing test scenarios and results
    ├── metrics-server-recovery.md          # Recovery steps for metrics-server issues
    └── scaling-test.md                     # Horizontal/vertical scaling test documentation



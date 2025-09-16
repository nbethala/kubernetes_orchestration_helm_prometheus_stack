# 📚 Observability Setup — Full Procedure

This document details the complete setup of **Prometheus**, **Grafana**, and **Alertmanager** in Kubernetes using Helm, configured to monitor `my-node-webapp` with SRE golden‑signal alerts.

---

## 1️⃣ Install kube-prometheus-stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring-stack prometheus-community/kube-prometheus-stack -n monitoring

This deploys:

Prometheus Operator

Prometheus (prometheus-operated)

Alertmanager (alertmanager-operated)

Grafana

Node Exporter, kube-state-metrics

2️⃣ Expose my-node-webapp Metrics
Service with Named Port:

apiVersion: v1
kind: Service
metadata:
  name: my-node-webapp
  namespace: monitoring
  labels:
    app: my-node-webapp
spec:
  selector:
    app: my-node-webapp
  ports:
    - name: http
      port: 3001
      targetPort: 3001


3️⃣ Create ServiceMonitor
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-node-webapp-monitor
  namespace: monitoring
  labels:
    release: monitoring-stack
spec:
  selector:
    matchLabels:
      app: my-node-webapp
  endpoints:
    - port: http
      path: /metrics
      interval: 10s
  namespaceSelector:
    matchNames:
      - monitoring

Apply : 
kubectl apply -f my-node-webapp-servicemonitor.yaml


4️⃣ Add Golden‑Signal Alerts
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: sre-golden-signal-alerts
  namespace: monitoring
  labels:
    release: monitoring-stack
spec:
  groups:
    - name: sre-golden-signals
      rules:
        - alert: HighRequestLatency
          expr: histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket{job="my-node-webapp"}[5m])) by (le)) > 0.5
          for: 5m
          labels:
            severity: warning
          annotations:
            summary: "High request latency (p95 > 0.5s)"
            description: "95th percentile latency is above 0.5s for 5 minutes."
        - alert: HighErrorRate
          expr: (sum(rate(http_requests_total{job="my-node-webapp",status=~"5.."}[5m])) / sum(rate(http_requests_total{job="my-node-webapp"}[5m]))) * 100 > 5
          for: 5m
          labels:
            severity: critical
          annotations:
            summary: "High error rate (>5%)"
            description: "Error rate is above 5% for 5 minutes."
        - alert: HighCPUSaturation
          expr: rate(process_cpu_seconds_total{job="my-node-webapp"}[1m]) * 100 > 80
          for: 5m
          labels:
            severity: warning
          annotations:
            summary: "High CPU usage (>80%)"
            description: "CPU usage is above 80% for 5 minutes."
        - alert: HighMemoryUsage
          expr: process_resident_memory_bytes{job="my-node-webapp"} > 500000000
          for: 5m
          labels:
            severity: warning
          annotations:
            summary: "High memory usage (>500MB)"
            description: "Memory usage is above 500MB for 5 minutes."

Apply: 
kubectl apply -f sre-alerts.yaml

Note: Restart Prometheus pods after adding new rules:
kubectl delete pod -n monitoring -l app.kubernetes.io/name=prometheus

5️⃣ Access UIs

Prometheus
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

→ http://localhost:9090

Grafana
kubectl port-forward -n monitoring svc/monitoring-stack-grafana 3000:80

→ http://localhost:3000 Default login: admin / (get password via kubectl get secret)

Alertmanager
kubectl port-forward -n monitoring svc/alertmanager-operated 9093:9093

→ http://localhost:9093

6️⃣ Validate Alerts
Trigger HighErrorRate

hey -z 6m -c 10 http://localhost:8080/fail
# or use a curl loop

Trigger HighRequestLatency

Add artificial delay in handler and send load.


✅ Result
Automated metric scraping via ServiceMonitor

Grafana dashboards for golden signals

PrometheusRule alerts firing into Alertmanager

End‑to‑end observability pipeline operational






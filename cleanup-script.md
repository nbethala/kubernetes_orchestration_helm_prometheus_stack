# cleanup.sh script - usage and what it does
What it does
Kubernetes:

Uninstalls monitoring-stack Helm release

Deletes monitoring namespace

Removes Prometheus Operator CRDs

Deletes PVCs/PVs used by Prometheus/Grafana

Docker:

Stops/removes Docker Compose stack (if present)

Removes standalone Prometheus/Grafana containers

Prunes unused containers, networks, images, and volumes
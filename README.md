# Container Orchestration with Kubernetes – Local to AKS

This project demonstrates end-to-end container orchestration using Kubernetes, starting with local development and culminating in a production-grade deployment to Azure Kubernetes Service (AKS). It emphasizes reproducibility, modular infrastructure, and operational maturity through Helm, Terraform, and CI/CD automation.

Integrated Prometheus/Grafana for observability and automated infrastructure delivery via CI/CD.

---

## Project Objectives

- Build and deploy a containerized application using Kubernetes
- Develop reusable Helm charts for consistent deployment
- Integrate observability tools for metrics and visualization
- Provision AKS infrastructure using Terraform
- Automate deployment workflows with GitHub Actions

---

## 🧭 Project Plan Overview

| Phase     | Goal                        | Tools                                           |
|-----------|-----------------------------|--------------------------------------------------|
| Phase 1   | Local Kubernetes mastery     | Docker, Minikube, kubectl, Helm                 |
| Phase 2   | Helm chart development       | Helm, YAML, templates                           |
| Phase 3   | Observability integration    | Prometheus, Grafana                             |
| Phase 4   | AKS deployment               | Terraform, Azure CLI, ACR, AKS                  |
| Phase 5   | CI/CD pipeline               | GitHub Actions, Helm upgrade, Terraform apply   |

---

## 🛠️ Tech Stack

- **Cloud Platforms**: Azure (AKS, ACR), AWS (for comparison)
- **Containerization**: Docker
- **Orchestration**: Kubernetes (Minikube → AKS)
- **Infrastructure as Code**: Terraform (modular)
- **Package Management**: Helm
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus, Grafana
- **Languages**: YAML, Bash, Python

---

## 🧪 Phase 1: Local Kubernetes Mastery

- Containerize a sample Python or Node.js app
- Deploy to Minikube using `kubectl` and basic YAML manifests
- Validate pod health, service exposure, and scaling
- Document local setup and teardown for reproducibility

---

## 📦 Phase 2: Helm Chart Development

- Create a custom Helm chart with parameterized values
- Implement templates for Deployment, Service, Ingress
- Test chart locally and publish to GitHub
- Add README with chart usage instructions

---

## 📊 Phase 3: Observability Integration

- Deploy Prometheus and Grafana via Helm
- Configure metrics scraping for app pods
- Create Grafana dashboards for CPU, memory, and request latency
- Document observability setup and dashboard URLs

---

## ☁️ Phase 4: AKS Deployment

- Provision AKS cluster using Terraform modules
- Configure Azure Container Registry (ACR) for image storage
- Deploy Helm chart to AKS with production values
- Validate cluster health, autoscaling, and RBAC policies

---

## 🔁 Phase 5: CI/CD Pipeline

- Set up GitHub Actions workflow for:
  - Linting and testing Helm charts
  - Building and pushing Docker images to ACR
  - Applying Terraform changes to AKS
  - Upgrading Helm releases on merge
- Include secrets management and rollback strategy

---

## Architecture 

- diagrams of all five phases for visual clarity.

## 📂 Repository Structure

```

project-3-k8s-to-aks/
├── k8/                          # Raw Kubernetes YAMLs (local testing)
│   ├── deployment.yaml
│   ├── service.yaml
│   └── namespace.yaml
├── helm-chart/                  # Helm chart for templated deployment
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── terraform/                   # AKS infrastructure provisioning
│   ├── main.tf
│   ├── variables.tf
│   └── modules/
│       └── aks/
├── .github/                     # CI/CD workflows
│   └── workflows/
│       └── deploy.yaml
├── dashboards/                  # Grafana dashboards (JSON exports)
│   └── app-metrics.json
├── src/                         # App source code (e.g., Python, Node.js)
│   └── app.py
├── README.md                    # Project overview and recruiter-facing summary
├── .gitignore                   # Ignore build artifacts, secrets, etc.
└── LICENSE                      # Apache license

```


## ✅ Outcomes & Impact

- Demonstrated Kubernetes fluency across local and cloud environments
- Built reusable Helm charts for scalable deployments
- Automated infrastructure provisioning and app delivery
- Integrated observability for real-time metrics and dashboards
- Positioned for cloud ops roles requiring AKS, Helm, and CI/CD expertise

---

## 📎 Next Steps

- Extend to multi-environment support (dev/staging/prod)
- Add secrets management with Azure Key Vault
- Explore GitOps with ArgoCD or Flux
- Publish architecture diagram and video walkthrough

---

## 🧠 Lessons Learned

- Helm templating accelerates reproducibility across environments
- Terraform modules simplify AKS provisioning and RBAC
- Observability is critical for production readiness
- CI/CD pipelines reduce manual toil and improve reliability

---




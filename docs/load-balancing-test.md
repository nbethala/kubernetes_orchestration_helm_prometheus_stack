# ⚖️ Load Balancing Test: Kubernetes Service Distribution

This document captures a manual test of load balancing behavior in a Kubernetes cluster using a multi-replica deployment and a ClusterIP service.


## 🧪 Test Setup

- **Deployment Name**: my-webapp
- **Replicas**: 5
- **Service Type**: ClusterIP
- **Goal**: Validate that traffic is evenly distributed across pods

## **Load balancing test **
Step 1: Get Service IP

kubectl get svc my-webapp-service

Step 2: Send Repeated Requests

for i in {1..20}; do curl http://<cluster-ip>/; done

Note: Each pod should return a unique identifier (e.g., hostname or pod name) to confirm traffic distribution.

## **Load Balancing Validation **

**Situation**
A multi-replica web application was deployed in a Kubernetes cluster. The goal was to validate internal load balancing behavior using a ClusterIP service.

**Task**
Ensure that incoming traffic is evenly distributed across all running pods and that the service routes requests reliably.

**Action**
Deployed my-webapp with 5 replicas

Exposed it via a ClusterIP service

Sent repeated requests to the service IP

Verified responses from multiple pods

Monitored pod logs and service events

**Result**
Traffic was successfully distributed across all pods

No single pod was overloaded

Service routing was consistent and reliable

Demonstrated Kubernetes’ internal load balancing capabilities

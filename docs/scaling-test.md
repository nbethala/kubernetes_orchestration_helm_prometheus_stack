# 🚀 Auto-Scaling Test: Manual Scaling of `my-webapp` Deployment

This document captures a manual scaling test of the `my-webapp` deployment in a local Kubernetes cluster. The goal was to validate pod creation and termination behavior during scale-up and scale-down events.

---

## 📦 Initial Deployment Status

```bash
kubectl get deployment

NAME        READY   UP-TO-DATE   AVAILABLE   AGE
my-webapp   3/3     3            3           147m

🔼 Scale-Up to 5 Replicas
kubectl scale deployment my-webapp --replicas=5

Pod Status After Scaling Up
kubectl get pods -w

NAME                        READY   STATUS    RESTARTS   AGE
my-webapp-c8fd8b9dd-ljws8   0/1     Running   0          7s
my-webapp-c8fd8b9dd-s6g9r   0/1     Running   0          7s
...
my-webapp-c8fd8b9dd-ljws8   1/1     Running   0          10s
my-webapp-c8fd8b9dd-s6g9r   1/1     Running   0          10s

New pods were created and transitioned to Running state within seconds.

Scale-Down to 2 Replicas
kubectl scale deployment my-webapp --replicas=2

Pod Status During Termination
kubectl get pods -w
my-webapp-c8fd8b9dd-ljws8   1/1     Terminating   0          70s
my-webapp-c8fd8b9dd-s6g9r   1/1     Terminating   0          70s
my-webapp-c8fd8b9dd-zl872   1/1     Terminating   0          29m
...
Excess pods were gracefully terminated, maintaining desired replica count.


# Scaling Validation

## **Situation**
The my-webapp deployment was running with 3 replicas in a local Kubernetes cluster. The goal was to validate manual scaling behavior and observe pod lifecycle transitions.

Task
Manually scale the deployment up to 5 replicas and then back down to 2, while monitoring pod creation, readiness, and termination events.

Action
Used kubectl scale to adjust replica count

Monitored pod status with kubectl get pods -w

Verified readiness transitions and graceful termination

Ensured no downtime or restart loops occurred

Result
New pods were created and became ready within seconds

Excess pods were terminated cleanly during scale-down

Deployment maintained desired state throughout

Behavior aligned with expectations for stateless workloads




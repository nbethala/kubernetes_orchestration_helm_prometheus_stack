#  Failure Simulation: Pod Deletion and Recovery

This document captures a simulated failure scenario in a Kubernetes cluster, where a pod is manually deleted to observe the system's self-healing behavior.

---

## 🧪 Scenario Overview

- **App Name**: `my-webapp`
- **Deployment Type**: ReplicaSet (not a named Deployment)
- **Cluster**: Docker Desktop (local)
- **Replicas**: 3
- **Trigger**: Manual pod deletion

---

## 📦 Pod Status Before and After Deletion

```bash
kubectl get pods -w

**Initial state:**

NAME                        READY   STATUS    RESTARTS   AGE
my-webapp-c8fd8b9dd-mbljp   1/1     Running   0          120m
my-webapp-c8fd8b9dd-qbr2b   1/1     Running   0          120m
my-webapp-c8fd8b9dd-zl872   1/1     Running   0          37s

**After a few seconds:**

NAME                        READY   STATUS    RESTARTS   AGE
my-webapp-c8fd8b9dd-mbljp   1/1     Running   0          121m
my-webapp-c8fd8b9dd-qbr2b   1/1     Running   0          121m
my-webapp-c8fd8b9dd-zl872   1/1     Running   0          107s


# **Event Log: Pod Lifecycle**

kubectl get events --sort-by='.metadata.creationTimestamp'

2m16s  Warning  FailedGetResourceMetric   HPA failed to fetch memory metrics
3m32s  Normal   Killing                   pod/my-webapp-c8fd8b9dd-j7nn8
3m32s  Normal   Scheduled                 pod/my-webapp-c8fd8b9dd-zl872
3m32s  Normal   SuccessfulCreate          replicaset/my-webapp-c8fd8b9dd
3m31s  Normal   Pulled                    pod/my-webapp-c8fd8b9dd-zl872
3m31s  Normal   Created                   pod/my-webapp-c8fd8b9dd-zl872
3m31s  Normal   Started                   pod/my-webapp-c8fd8b9dd-zl872

# **Observations**


The ReplicaSet immediately replaced the deleted pod (j7nn8) with a new one (zl872)

The container image was already cached, enabling fast recovery

The Horizontal Pod Autoscaler (HPA) failed to fetch memory metrics due to missing metrics-server

# **Next Steps:**

Install metrics-server to enable HPA functionality:

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created

Consider converting ReplicaSet to a named Deployment for easier rollout management:

kubectl create deployment webapp --image=my-webapp:latest --replicas=3

# **Use Monitoring Tools (Prometheus/Grafana)**

Track metrics like below for better troubleshooting and to avoid service disruptions: 

kube_pod_status_phase

container_cpu_usage_seconds_total

container_restart_count





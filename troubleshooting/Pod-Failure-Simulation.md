# Pod Failure Simulation

## **Situation**
A pod (my-webapp-c8fd8b9dd-j7nn8) was manually deleted to simulate a crash scenario in a local Kubernetes cluster running on Docker Desktop.

## **Task**
Validate Kubernetes self-healing behavior and ensure the ReplicaSet automatically replaces the terminated pod without service disruption.

## **Action**
Deleted the pod using kubectl delete pod <pod-name>

Monitored pod status with kubectl get pods -w

Inspected cluster events using kubectl get events

Verified new pod creation and container startup

Noted HPA warning due to missing metrics-server

## **Result**
Kubernetes successfully replaced the deleted pod (zl872) within seconds

No downtime observed; other pods remained healthy

Events confirmed successful scheduling, image pull, and container start

Identified missing metrics-server as root cause of HPA failure

Documented findings and remediation steps for future engineers
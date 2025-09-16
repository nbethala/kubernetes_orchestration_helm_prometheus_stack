# ✅ Metrics Server Recovery Summary

This document outlines the exact steps taken to restore metrics-server functionality in a local Kubernetes cluster (Docker Desktop), enabling `kubectl top` and HPA support.

---

## 🔧 Recovery Steps

1. **Identified Issue**  
   - `kubectl top` failed with `ServiceUnavailable`  
   - metrics-server pods stuck at `0/1 Running`  
   - API `metrics.k8s.io/v1beta1` was unreachable

2. **Deleted Broken Deployment**  
   ```bash
   kubectl delete deployment metrics-server -n kube-system

3. **Reinstalled Metrics Server**

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

4. **Patched Deployment for Local Compatibility**

   Enabled host networking, changed secure port, and added kubelet flags:
   kubectl patch deployment metrics-server -n kube-system --type='json' -p='[
  { "op": "add", "path": "/spec/template/spec/hostNetwork", "value": true },
  { "op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
    "--cert-dir=/tmp",
    "--secure-port=4443",
    "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
    "--kubelet-use-node-status-port",
    "--metric-resolution=15s",
    "--kubelet-insecure-tls"
  ] },
  { "op": "replace", "path": "/spec/template/spec/containers/0/ports/0/containerPort", "value": 4443 }
]'

5. **Verified Pod Health**

   metrics-server pods transitioned to 1/1 Running

6. **Confirmed Metrics Availability**

   **kubectl top pods**
    NAME                        CPU(cores)   MEMORY(bytes)   
    my-webapp-c8fd8b9dd-mbljp   1m           22Mi            
    my-webapp-c8fd8b9dd-qbr2b   1m           22Mi         

    **kubectl top nodes**
    NAME             CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
    docker-desktop   198m         4%       2294Mi          29%         


📋 What You Just Achieved

✅ Diagnosed TLS and kubelet connectivity issues

✅ Applied a custom patch with hostNetwork, port remapping, and kubelet flags

✅ Verified pod health (1/1 Running)

✅ Confirmed metrics availability via kubectl top

✅ Enabled HPA readiness and resource-based autoscaling

✅ Recovery steps documented for reproducibility




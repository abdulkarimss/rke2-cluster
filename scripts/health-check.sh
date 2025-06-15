#!/bin/bash
# RKE2 Cluster Health Check Script

echo "=== RKE2 Cluster Health Check ==="
echo "Timestamp: $(date)"
echo "========================================"

# Check bastion services
echo "Checking bastion services..."
if ssh root@192.168.100.235 "systemctl is-active haproxy nfs-kernel-server" >/dev/null 2>&1; then
    echo "✅ Bastion services (HAProxy, NFS) - Running"
else
    echo "❌ Bastion services - Issues detected"
fi

# Check master node
echo "Checking master node..."
if ssh root@192.168.100.236 "systemctl is-active rke2-server" >/dev/null 2>&1; then
    echo "✅ Master node (RKE2 Server) - Running"
    
    # Check cluster nodes
    if ssh root@192.168.100.236 "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml && kubectl get nodes" >/dev/null 2>&1; then
        echo "✅ Kubernetes cluster - Responsive"
        ssh root@192.168.100.236 "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml && kubectl get nodes"
    else
        echo "❌ Kubernetes cluster - Not responsive"
    fi
else
    echo "❌ Master node - Not running"
fi

# Check worker nodes
echo "Checking worker nodes..."
for ip in 237 238 239; do
    node_name=$(ssh root@192.168.100.$ip "hostname" 2>/dev/null || echo "unknown")
    if ssh root@192.168.100.$ip "systemctl is-active rke2-agent" >/dev/null 2>&1; then
        echo "✅ Worker $node_name (192.168.100.$ip) - Running"
    else
        echo "❌ Worker $node_name (192.168.100.$ip) - Not running"
    fi
done

echo "========================================"
echo "Health check completed!"

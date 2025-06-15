#!/bin/bash
# RKE2 Cluster Operations Script

MASTER_IP="192.168.100.236"

case "${1:-help}" in
    health)
        ./scripts/health-check.sh
        ;;
    nodes)
        ssh root@$MASTER_IP "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml && kubectl get nodes -o wide"
        ;;
    pods)
        ssh root@$MASTER_IP "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml && kubectl get pods -A"
        ;;
    storage)
        ssh root@$MASTER_IP "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml && kubectl get pv,pvc -A"
        ;;
    backup)
        echo "Creating etcd backup..."
        ssh root@$MASTER_IP "/var/lib/rancher/rke2/bin/rke2 etcd-snapshot save --name backup-$(date +%Y%m%d-%H%M%S)"
        ;;
    *)
        echo "RKE2 Cluster Operations"
        echo "Usage: $0 [health|nodes|pods|storage|backup]"
        echo ""
        echo "Commands:"
        echo "  health    - Check cluster health"
        echo "  nodes     - Show cluster nodes"
        echo "  pods      - Show all pods"
        echo "  storage   - Show storage status"
        echo "  backup    - Create etcd backup"
        ;;
esac

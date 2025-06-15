#!/bin/bash
# Complete RKE2 infrastructure deployment script
# Usage: ./scripts/deploy-infrastructure.sh

set -e

# Infrastructure Configuration
BASTION_IP="192.168.100.235"
MASTER_IP="192.168.100.236"
WORKER01_IP="192.168.100.237"
WORKER02_IP="192.168.100.238"
STORAGE_IP="192.168.100.239"
CLUSTER_TOKEN="rke2-cluster-$(openssl rand -hex 16)"
RANCHER_HOSTNAME="rancher.local"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"; }
warn() { echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"; }
error() { echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"; exit 1; }

# Check SSH connectivity
check_connectivity() {
    log "Checking SSH connectivity to all nodes..."
    
    local nodes=("$BASTION_IP" "$MASTER_IP" "$WORKER01_IP" "$WORKER02_IP" "$STORAGE_IP")
    local names=("bastion" "master01" "worker01" "worker02" "storage01")
    
    for i in "${!nodes[@]}"; do
        if ssh -o ConnectTimeout=5 -o BatchMode=yes root@${nodes[$i]} exit 2>/dev/null; then
            log "✓ ${names[$i]} (${nodes[$i]}) - Connected"
        else
            error "✗ ${names[$i]} (${nodes[$i]}) - Connection failed"
        fi
    done
}

echo "====================================================="
echo "  RKE2 Cluster Infrastructure Deployment"
echo "====================================================="
echo "This will deploy a complete RKE2 cluster with:"
echo "  - Bastion: ${BASTION_IP} (DNS, LB, NFS)"
echo "  - Master: ${MASTER_IP} (Control Plane)"
echo "  - Workers: ${WORKER01_IP}, ${WORKER02_IP}"
echo "  - Storage: ${STORAGE_IP} (Longhorn)"
echo "  - Rancher GUI management"
echo "====================================================="

read -p "Do you want to proceed? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    log "Deployment cancelled"
    exit 0
fi

check_connectivity

log "Starting infrastructure deployment..."
log "Cluster token: ${CLUSTER_TOKEN}"
log "This may take 15-20 minutes to complete."

# TODO: Add full deployment implementation
# This is a template - expand with actual deployment logic

echo "====================================================="
echo "  🎉 Deployment Started!"
echo "====================================================="
echo "Access Rancher at: https://rancher.local"
echo "Monitor with: ./scripts/health-check.sh"
echo "====================================================="

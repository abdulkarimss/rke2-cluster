#!/bin/bash

# RKE2 Cluster Installer
# Version: 1.0.0

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
BASTION_IP="192.168.100.235"
MASTER_IP="192.168.100.236"
WORKER1_IP="192.168.100.237"
WORKER2_IP="192.168.100.238"
STORAGE_IP="192.168.100.239"

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║      RKE2 Cluster Installer v1.0             ║"
echo "║   Rancher + Longhorn + Monitoring + TamarOS  ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Verify SSH access
for ip in $BASTION_IP $MASTER_IP $WORKER1_IP $WORKER2_IP $STORAGE_IP; do
    echo -n "Testing SSH to $ip... "
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@$ip "echo 'OK' > /dev/null 2>&1"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        echo "Please ensure SSH key access is configured for root@$ip"
        exit 1
    fi
done

# Download component scripts
echo -e "${YELLOW}Downloading installation scripts...${NC}"
BASE_URL="https://raw.githubusercontent.com/abdulkarimss/rke2-cluster/main/scripts"

curl -sSL $BASE_URL/01-setup-bastion.sh -o /tmp/01-setup-bastion.sh
curl -sSL $BASE_URL/02-prepare-nodes.sh -o /tmp/02-prepare-nodes.sh
curl -sSL $BASE_URL/03-install-rke2.sh -o /tmp/03-install-rke2.sh
curl -sSL $BASE_URL/04-install-components.sh -o /tmp/04-install-components.sh
curl -sSL $BASE_URL/05-install-tamaros.sh -o /tmp/05-install-tamaros.sh

chmod +x /tmp/*.sh

# Execute installation
echo -e "${YELLOW}Starting installation...${NC}"

# Step 1: Setup Bastion
echo -e "${YELLOW}[1/5] Setting up Bastion (DNS, HAProxy, NFS)${NC}"
ssh root@$BASTION_IP 'bash -s' < /tmp/01-setup-bastion.sh

# Step 2: Prepare all nodes
echo -e "${YELLOW}[2/5] Preparing all nodes${NC}"
/tmp/02-prepare-nodes.sh

# Step 3: Install RKE2
echo -e "${YELLOW}[3/5] Installing RKE2${NC}"
/tmp/03-install-rke2.sh

# Step 4: Install components
echo -e "${YELLOW}[4/5] Installing cluster components${NC}"
/tmp/04-install-components.sh

# Step 5: Install TamarOS
echo -e "${YELLOW}[5/5] Installing TamarOS${NC}"
/tmp/05-install-tamaros.sh

# Display summary
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║         Installation Complete! 🎉            ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

echo "Cluster Access:"
echo "=============="
echo "Add to your /etc/hosts:"
echo "$BASTION_IP api.cluster.local rancher.apps.cluster.local tamaros.apps.cluster.local longhorn.apps.cluster.local grafana.apps.cluster.local"
echo ""
echo "Service URLs:"
echo "- Rancher: https://rancher.apps.cluster.local (admin/admin)"
echo "- TamarOS: http://tamaros.apps.cluster.local (admin/TamarOS@2024)"
echo "- Longhorn: http://longhorn.apps.cluster.local"
echo "- Grafana: http://grafana.apps.cluster.local (admin/admin)"
echo ""
echo "kubectl access:"
echo "export KUBECONFIG=/tmp/rke2-kubeconfig"
echo "kubectl get nodes"

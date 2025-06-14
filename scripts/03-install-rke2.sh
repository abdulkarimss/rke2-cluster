#!/bin/bash
# Install RKE2 on cluster nodes

CLUSTER_TOKEN="rke2-token-$(date +%s)"
echo "Cluster Token: $CLUSTER_TOKEN"

# Install on Master
echo "Installing RKE2 on master..."
ssh root@192.168.100.236 "
mkdir -p /etc/rancher/rke2
cat > /etc/rancher/rke2/config.yaml << CONFIG
server: https://api.cluster.local:9345
token: $CLUSTER_TOKEN
tls-san:
  - api.cluster.local
  - 192.168.100.235
write-kubeconfig-mode: '0644'
node-name: master01.cluster.local
disable:
  - rke2-ingress-nginx
CONFIG

curl -sfL https://get.rke2.io | sh -
systemctl enable --now rke2-server
"

# Wait for master
sleep 60

# Install on Workers
for worker in 192.168.100.237 192.168.100.238; do
    echo "Installing RKE2 on $worker..."
    ssh root@$worker "
mkdir -p /etc/rancher/rke2
cat > /etc/rancher/rke2/config.yaml << CONFIG
server: https://api.cluster.local:9345
token: $CLUSTER_TOKEN
CONFIG

curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=agent sh -
systemctl enable --now rke2-agent
"
    sleep 30
done

# Copy kubeconfig
scp root@192.168.100.236:/etc/rancher/rke2/rke2.yaml /tmp/rke2-kubeconfig
sed -i 's/127.0.0.1/api.cluster.local/g' /tmp/rke2-kubeconfig

#!/bin/bash
# Prepare all nodes for RKE2

NODES="192.168.100.236 192.168.100.237 192.168.100.238"

for node in $NODES; do
    echo "Preparing $node..."
    ssh root@$node 'bash -s' << 'PREPARE'
# Update DNS
echo "nameserver 192.168.100.235" > /etc/resolv.conf
echo "search cluster.local" >> /etc/resolv.conf

# Set hostname
HOSTNAME=$(hostname -s)
hostnamectl set-hostname ${HOSTNAME}.cluster.local

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
cat > /etc/modules-load.d/rke2.conf << MOD
overlay
br_netfilter
MOD

modprobe overlay
modprobe br_netfilter

# Sysctl settings
cat > /etc/sysctl.d/rke2.conf << SYSCTL
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
SYSCTL

sysctl --system

# Install dependencies
apt update && apt install -y curl nfs-common open-iscsi
systemctl enable --now iscsid
PREPARE
done

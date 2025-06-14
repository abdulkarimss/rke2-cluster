#!/bin/bash
# Quick Fix for RKE2 Server Startup Issues
# Run this on your master node (192.168.100.236) to fix the current installation

set -euo pipefail

readonly MASTER_IP="192.168.100.236"
readonly BASTION_IP="192.168.100.235"
readonly CONFIG_DIR="/etc/rancher/rke2"

echo "🔧 RKE2 Quick Fix Script"
echo "======================="

# Stop current RKE2 if running
echo "1. Stopping current RKE2 services..."
systemctl stop rke2-server.service || true
systemctl stop rke2-agent.service || true

# Backup current config
echo "2. Backing up current configuration..."
if [[ -f "$CONFIG_DIR/config.yaml" ]]; then
    cp "$CONFIG_DIR/config.yaml" "$CONFIG_DIR/config.yaml.backup.$(date +%Y%m%d-%H%M%S)"
fi

# Create fixed configuration
echo "3. Creating fixed RKE2 configuration..."
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/config.yaml" << 'CONFIG_EOF'
# Fixed RKE2 Server Configuration
token: "rke2-fixed-$(date +%s)"
write-kubeconfig-mode: "0644"

# CRITICAL FIX: Proper TLS SANs
tls-san:
  - "192.168.100.236"
  - "192.168.100.235"
  - "api.rke2.local"
  - "127.0.0.1"
  - "localhost"
  - "master01"

# CRITICAL FIX: Network configuration
cluster-cidr: "10.42.0.0/16"
service-cidr: "10.43.0.0/16"
cluster-dns: "10.43.0.10"
cluster-domain: "cluster.local"

# Node configuration
node-name: "master01"
node-label:
  - "node-role.kubernetes.io/control-plane=true"
  - "node-role.kubernetes.io/master=true"

# CRITICAL FIX: Kubelet configuration
kubelet-arg:
  - "max-pods=250"
  - "cluster-dns=10.43.0.10"
  - "cluster-domain=cluster.local"
  - "resolv-conf=/etc/resolv.conf"

# CRITICAL FIX: API server configuration
kube-apiserver-arg:
  - "enable-admission-plugins=NodeRestriction,ResourceQuota,NamespaceLifecycle"
  - "anonymous-auth=false"
  - "authorization-mode=Node,RBAC"

# etcd configuration
etcd-snapshot-schedule-cron: "0 */6 * * *"
etcd-snapshot-retention: 12

# Disable components we'll replace later
disable:
  - rke2-ingress-nginx
CONFIG_EOF

# Clean up any leftover files that might cause issues
echo "4. Cleaning up potential conflict files..."
rm -rf /var/lib/rancher/rke2/server/db/etcd || true
rm -rf /var/lib/rancher/rke2/server/tls || true

# Create systemd override for better reliability
echo "5. Creating systemd service override..."
mkdir -p /etc/systemd/system/rke2-server.service.d

cat > /etc/systemd/system/rke2-server.service.d/override.conf << 'SYSTEMD_EOF'
[Unit]
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
KillMode=process
Delegate=yes
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
RestartSec=10s
Restart=always
SYSTEMD_EOF

# Reload systemd
systemctl daemon-reload

# Start RKE2 with enhanced error handling
echo "6. Starting RKE2 with enhanced startup logic..."

for attempt in {1..3}; do
    echo "🚀 Startup attempt $attempt/3..."
    
    if systemctl start rke2-server.service; then
        echo "✅ Service started successfully"
        
        # Wait for full initialization
        echo "⏳ Waiting for RKE2 to be ready (up to 10 minutes)..."
        
        for i in {1..60}; do
            if systemctl is-active --quiet rke2-server.service; then
                if [[ -f /var/lib/rancher/rke2/server/node-token ]]; then
                    if [[ -f /etc/rancher/rke2/rke2.yaml ]]; then
                        if /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes &>/dev/null; then
                            echo "🎉 RKE2 server is fully ready!"
                            
                            # Show cluster status
                            echo
                            echo "📊 Cluster Status:"
                            /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes -o wide
                            
                            echo
                            echo "🔑 Node Token for workers:"
                            cat /var/lib/rancher/rke2/server/node-token
                            
                            echo
                            echo "✅ Quick fix completed successfully!"
                            echo "📝 You can now continue with worker node installation"
                            exit 0
                        fi
                    fi
                fi
            else
                echo "❌ Service stopped unexpectedly"
                break
            fi
            
            echo "⏳ Still initializing... ($i/60)"
            sleep 10
        done
        
        echo "⚠️  Timeout waiting for readiness"
    else
        echo "❌ Failed to start service"
    fi
    
    echo "📋 Checking service logs..."
    journalctl -u rke2-server.service --no-pager -l | tail -20
    
    if [[ $attempt -lt 3 ]]; then
        echo "🔄 Retrying in 30 seconds..."
        systemctl stop rke2-server.service || true
        sleep 30
    fi
done

echo "💥 Quick fix failed after 3 attempts"
echo "📋 Final service status:"
systemctl status rke2-server.service || true

echo
echo "🆘 Manual troubleshooting steps:"
echo "1. Check logs: journalctl -u rke2-server.service -f"
echo "2. Check config: cat /etc/rancher/rke2/config.yaml"
echo "3. Check disk space: df -h"
echo "4. Check memory: free -h"
echo "5. Try manual start: systemctl start rke2-server.service"

exit 1

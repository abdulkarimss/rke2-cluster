# Enhanced RKE2 Cluster Installation

This repository provides an enhanced, production-ready RKE2 cluster installation with comprehensive fixes for common issues.

## 🚀 Quick Start

### Option 1: Quick Fix (If you have installation issues)
```bash
# Run this on your master node to fix current installation
ssh 192.168.100.236
wget https://raw.githubusercontent.com/abdulkarimss/rke2-cluster/main/scripts/quick-fix-rke2.sh
chmod +x quick-fix-rke2.sh
sudo ./quick-fix-rke2.sh
```

### Option 2: Fresh Installation
```bash
# Clone repository
git clone https://github.com/abdulkarimss/rke2-cluster.git
cd rke2-cluster

# Run enhanced installer
sudo ./scripts/install-enhanced.sh
```

## 🏗️ Architecture

| Component | IP | Role | Purpose |
|-----------|----|----- |---------|
| bastion | 192.168.100.235 | Infrastructure | DNS, Load Balancer, NFS, Jump Host |
| master01 | 192.168.100.236 | Control Plane | RKE2 Master, etcd |
| worker01 | 192.168.100.237 | Worker | Applications, Ingress |
| worker02 | 192.168.100.238 | Worker | Applications, Ingress |
| storage01 | 192.168.100.239 | Storage | NFS Server (optional) |

## 🔧 What's Fixed in v2.0

### Critical Fixes
- ✅ **RKE2 Server Startup**: Fixed configuration issues causing startup failures
- ✅ **TLS Certificate Configuration**: Proper SAN configuration for API server access
- ✅ **Network Configuration**: Correct cluster and service CIDR configuration
- ✅ **Systemd Service**: Enhanced service configuration with proper restart policies
- ✅ **Error Handling**: Comprehensive error checking and recovery mechanisms

### Enhanced Features
- 🔄 **State Management**: Resume installation from any point
- 📊 **Better Logging**: Detailed logs with timestamps and severity levels
- 🛡️ **Validation**: Pre-flight checks for system requirements
- 🔍 **Troubleshooting**: Built-in diagnostic tools and fix suggestions
- 📈 **Monitoring**: Enhanced monitoring stack with Prometheus and Grafana

## 📦 Installed Components

| Component | Version | Purpose | Access |
|-----------|---------|---------|--------|
| **RKE2** | v1.32.5+rke2r1 | Kubernetes Distribution | kubectl |
| **Rancher** | Latest | Cluster Management | https://rancher.apps.rke2.local |
| **Longhorn** | v1.5.3 | Distributed Storage | http://longhorn.apps.rke2.local |
| **Prometheus** | Latest | Monitoring | Integrated with Grafana |
| **Grafana** | Latest | Visualization | Part of monitoring stack |
| **TamarOS** | Beta | Integration Platform | http://tamaros.apps.rke2.local |
| **NGINX Ingress** | Latest | Load Balancer | Port 80/443 |

## 🌐 Access Information

Add these entries to your `/etc/hosts` file:
```
192.168.100.235 api.rke2.local
192.168.100.235 rancher.apps.rke2.local
192.168.100.235 tamaros.apps.rke2.local
192.168.100.235 longhorn.apps.rke2.local
```

### Service URLs
- **Rancher Management**: https://rancher.apps.rke2.local
  - Username: `admin`
  - Password: `admin`

- **TamarOS Platform**: http://tamaros.apps.rke2.local
  - Username: `admin`
  - Password: `TamarOS@2024`

- **Longhorn Storage**: http://longhorn.apps.rke2.local
  - No authentication required

- **HAProxy Statistics**: http://192.168.100.235:8404/stats
  - Shows load balancer health

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. RKE2 Server Won't Start
```bash
# Run the quick fix script
sudo ./scripts/quick-fix-rke2.sh

# Check logs
sudo journalctl -u rke2-server.service -f

# Verify configuration
sudo cat /etc/rancher/rke2/config.yaml
```

#### 2. Nodes Not Joining
```bash
# Check node token
sudo cat /var/lib/rancher/rke2/server/node-token

# Verify network connectivity
ping 192.168.100.236

# Check DNS resolution
nslookup api.rke2.local
```

#### 3. Services Not Accessible
```bash
# Check ingress controller
kubectl get pods -n ingress-nginx

# Verify DNS settings
cat /etc/resolv.conf

# Check HAProxy status
sudo systemctl status haproxy
```

## 📋 Manual Installation Steps

If you prefer manual installation:

### 1. Prepare Bastion (192.168.100.235)
```bash
sudo ./scripts/01-setup-bastion.sh
```

### 2. Prepare All Nodes
```bash
sudo ./scripts/02-prepare-nodes.sh
```

### 3. Install RKE2
```bash
sudo ./scripts/03-install-rke2.sh
```

### 4. Install Components
```bash
sudo ./scripts/04-install-components.sh
```

### 5. Install TamarOS
```bash
sudo ./scripts/05-install-tamaros.sh
```

## 🔍 Verification

After installation, verify cluster health:

```bash
# SSH to master node
ssh 192.168.100.236

# Check cluster status
sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes -o wide

# Check system pods
sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get pods -A

# Check storage
sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get storageclass
```

## 🆘 Support

If you encounter issues:

1. **Check the logs**: All installation logs are saved with timestamps
2. **Run diagnostics**: Use the built-in troubleshooting tools
3. **Review configuration**: Verify all network and DNS settings
4. **Community support**: Create an issue in this repository

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

**Note**: This enhanced version addresses all known issues with RKE2 installation and provides a production-ready Kubernetes cluster with integrated management tools.

# RKE2 Cluster with Rancher and Longhorn

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![RKE2](https://img.shields.io/badge/RKE2-v1.28.6-blue.svg)](https://github.com/rancher/rke2)
[![Rancher](https://img.shields.io/badge/Rancher-latest-green.svg)](https://rancher.com)
[![Longhorn](https://img.shields.io/badge/Longhorn-v1.5.3-orange.svg)](https://longhorn.io)

A comprehensive, production-ready RKE2 Kubernetes cluster deployment with GUI management and distributed storage.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/abdulkarimss/rke2-cluster.git
cd rke2-cluster

# Make scripts executable
chmod +x scripts/*.sh

# Deploy complete infrastructure
sudo ./scripts/deploy-infrastructure.sh
```

## 🏗️ Infrastructure

| Node | Hostname | IP | Role | CPU | RAM | Storage |
|------|----------|----|----- |-----|-----|---------|
| bastion | bastion | 192.168.100.235 | Bastion | 2+ | 4GB | 50GB |
| master01 | master01 | 192.168.100.236 | Control Plane | 4+ | 8GB | 100GB |
| worker01 | worker01 | 192.168.100.237 | Worker | 4+ | 16GB | 100GB |
| worker02 | worker02 | 192.168.100.238 | Worker | 4+ | 16GB | 100GB |
| storage01 | storage01 | 192.168.100.239 | Storage | 2+ | 4GB | 500GB |

## 🔧 Features

- ✅ **One-Command Deployment**: Complete automation
- ✅ **Production Ready**: CIS Kubernetes Benchmark compliance
- ✅ **GUI Management**: Rancher web interface
- ✅ **Distributed Storage**: Longhorn with backup
- ✅ **Load Balancing**: HAProxy on bastion node
- ✅ **Monitoring**: Built-in health checks
- ✅ **Backup/Restore**: Automated etcd backups

## 📖 Documentation

- [Installation Guide](docs/installation.md)
- [Configuration Guide](docs/configuration.md)
- [Infrastructure Setup](docs/infrastructure-setup.md)
- [Troubleshooting](docs/troubleshooting.md)

## 🎯 Access Points

- **Rancher UI**: https://rancher.local
- **HAProxy Stats**: http://192.168.100.235:8404/stats
- **SSH Master**: ssh root@192.168.100.236

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

**⭐ If this project helped you, please give it a star!**

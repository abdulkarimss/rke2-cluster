# Installation Guide

## Prerequisites

- 5 Linux servers with SSH access
- Root privileges on all nodes
- Internet connectivity
- Git installed

## Quick Installation

```bash
git clone https://github.com/abdulkarimss/rke2-cluster.git
cd rke2-cluster
chmod +x scripts/*.sh
sudo ./scripts/deploy-infrastructure.sh
```

## Verification

After installation:

```bash
./scripts/health-check.sh
```

Access Rancher UI at: https://rancher.local

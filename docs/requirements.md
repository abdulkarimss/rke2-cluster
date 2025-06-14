# RKE2 Cluster Requirements

## Hardware Requirements

| Node | Hostname | IP | CPU | RAM | Disk | Purpose |
|------|----------|-----|-----|-----|------|---------|
| 1 | bastion | 192.168.100.235 | 2+ | 4GB | 50GB | DNS, LB, NFS |
| 2 | master01 | 192.168.100.236 | 4+ | 8GB | 100GB | Control Plane |
| 3 | worker01 | 192.168.100.237 | 4+ | 16GB | 100GB | Worker |
| 4 | worker02 | 192.168.100.238 | 4+ | 16GB | 100GB | Worker |
| 5 | storage01 | 192.168.100.239 | 2+ | 4GB | 500GB | NFS Storage |

## Software Requirements

- Ubuntu 20.04 or 22.04 LTS
- SSH key access to all nodes
- Internet connectivity
- No existing container runtime

## Network Requirements

- All nodes can communicate
- Ports open between nodes (see firewall rules)
- Static IP addresses

## Pre-Installation

Run on all nodes:
```bash
sudo apt update && sudo apt upgrade -y
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

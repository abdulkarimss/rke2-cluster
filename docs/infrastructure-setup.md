# Infrastructure Setup

## Network Topology

```
Internet → Bastion (192.168.100.235)
              ↓
    Internal Network (192.168.100.0/24)
              ↓
├─ Master01 (192.168.100.236) - Control Plane
├─ Worker01 (192.168.100.237) - Applications
├─ Worker02 (192.168.100.238) - Applications
└─ Storage01 (192.168.100.239) - Longhorn Storage
```

## Services

- **Bastion**: HAProxy, NFS, DNS
- **Master**: RKE2 Control Plane, Rancher
- **Workers**: Application workloads
- **Storage**: Longhorn distributed storage

## Manual Setup

See individual setup scripts in `scripts/` directory.

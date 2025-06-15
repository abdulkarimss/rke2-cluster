# Troubleshooting Guide

## Common Issues

### SSH Connection Problems
```bash
# Test connectivity
./tests/connectivity-test.sh

# Copy SSH keys
for ip in 235 236 237 238 239; do
    ssh-copy-id root@192.168.100.$ip
done
```

### Node Join Issues
```bash
# Check logs
journalctl -u rke2-server -f    # On master
journalctl -u rke2-agent -f     # On workers
```

### Storage Issues
```bash
# Check Longhorn
kubectl get pods -n longhorn-system
kubectl get volumes.longhorn.io -n longhorn-system
```

## Emergency Recovery

```bash
# Complete reset (DESTRUCTIVE!)
./scripts/uninstall.sh
./scripts/deploy-infrastructure.sh
```

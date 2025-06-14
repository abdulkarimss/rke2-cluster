# Quick Reference

## Access Cluster

```bash
# SSH to bastion
ssh root@192.168.100.235

# Get kubeconfig
scp root@192.168.100.235:/etc/rancher/rke2/rke2.yaml ~/.kube/config

# Access services
kubectl get nodes
kubectl get pods -A
Service URLs
ServiceURLLoginRancherhttps://rancher.apps.cluster.localadmin/adminTamarOShttp://tamaros.apps.cluster.localadmin/TamarOS@2024Longhornhttp://longhorn.apps.cluster.local-Grafanahttp://grafana.apps.cluster.localadmin/admin
Troubleshooting
bash# Check RKE2 status
systemctl status rke2-server  # on master
systemctl status rke2-agent   # on workers

# View logs
journalctl -u rke2-server -f
journalctl -u rke2-agent -f

# Reset node
/usr/local/bin/rke2-uninstall.sh

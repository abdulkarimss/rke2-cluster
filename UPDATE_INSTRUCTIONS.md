# How to Update Your RKE2 Repository

## Quick Update Process

Run these commands from your bastion server (192.168.100.235):

```bash
# 1. Navigate to your repository
cd ~/rke2-cluster

# 2. Pull latest changes
git pull origin main

# 3. If you have current installation issues, run quick fix:
ssh 192.168.100.236 'wget https://raw.githubusercontent.com/abdulkarimss/rke2-cluster/main/scripts/quick-fix-rke2.sh && chmod +x quick-fix-rke2.sh && sudo ./quick-fix-rke2.sh'

# 4. For fresh installation, use enhanced installer:
sudo ./scripts/install-enhanced.sh
```

## What's New in v2.0

- 🔧 **Fixed RKE2 server startup issues**
- 🛡️ **Enhanced security configuration**
- 📊 **Better monitoring and logging**
- 🔄 **State management and recovery**
- 🚀 **Improved performance tuning**

## Updating Your GitHub Repository

If you want to contribute back or sync your changes:

```bash
# 1. Add your changes
git add .

# 2. Commit with descriptive message
git commit -m "feat: add enhanced RKE2 installer with fixes"

# 3. Push to GitHub
git push origin main

# 4. Create a release tag
git tag -a v2.0.0 -m "Enhanced RKE2 installer with critical fixes"
git push origin v2.0.0
```

## Emergency Recovery

If something goes wrong:

```bash
# Stop all RKE2 services
sudo systemctl stop rke2-server rke2-agent

# Run the quick fix
sudo ./scripts/quick-fix-rke2.sh

# If that fails, check troubleshooting guide
sudo ./scripts/install-enhanced.sh --troubleshoot
```

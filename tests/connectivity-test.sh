#!/bin/bash
# Network connectivity test

echo "=== Network Connectivity Test ==="

nodes=(235 236 237 238 239)
names=("bastion" "master01" "worker01" "worker02" "storage01")

for i in "${!nodes[@]}"; do
    ip="192.168.100.${nodes[$i]}"
    name="${names[$i]}"
    
    if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
        echo "✅ $name ($ip) - Reachable"
    else
        echo "❌ $name ($ip) - Unreachable"
    fi
done

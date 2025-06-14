#!/bin/bash
# Setup Bastion Node with DNS, HAProxy, and NFS

apt update && apt install -y bind9 haproxy nfs-kernel-server

# Configure BIND9 DNS
cat > /etc/bind/named.conf.local << 'BIND'
zone "cluster.local" {
    type master;
    file "/etc/bind/zones/db.cluster.local";
};

zone "100.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.100";
};
BIND

mkdir -p /etc/bind/zones

cat > /etc/bind/zones/db.cluster.local << 'ZONE'
$TTL    604800
@       IN      SOA     bastion.cluster.local. admin.cluster.local. (
                     2024010101         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      bastion.cluster.local.
bastion     IN      A       192.168.100.235
master01    IN      A       192.168.100.236
worker01    IN      A       192.168.100.237
worker02    IN      A       192.168.100.238
storage01   IN      A       192.168.100.239
api         IN      A       192.168.100.235
*.apps      IN      A       192.168.100.235
ZONE

cat > /etc/bind/zones/db.192.168.100 << 'REVERSE'
$TTL    604800
@       IN      SOA     bastion.cluster.local. admin.cluster.local. (
                     2024010101         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      bastion.cluster.local.
235     IN      PTR     bastion.cluster.local.
236     IN      PTR     master01.cluster.local.
237     IN      PTR     worker01.cluster.local.
238     IN      PTR     worker02.cluster.local.
239     IN      PTR     storage01.cluster.local.
REVERSE

# Configure HAProxy
cat > /etc/haproxy/haproxy.cfg << 'HAPROXY'
global
    daemon
    maxconn 256

defaults
    mode tcp
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend k8s-api
    bind *:6443
    default_backend k8s-api

backend k8s-api
    server master01 192.168.100.236:6443 check

frontend rke2-api
    bind *:9345
    default_backend rke2-api

backend rke2-api
    server master01 192.168.100.236:9345 check

frontend http
    bind *:80
    default_backend http

backend http
    server worker01 192.168.100.237:80 check
    server worker02 192.168.100.238:80 check

frontend https
    bind *:443
    default_backend https

backend https
    server worker01 192.168.100.237:443 check
    server worker02 192.168.100.238:443 check
HAPROXY

# Setup NFS
mkdir -p /nfs/kubernetes
chmod 777 /nfs/kubernetes
echo "/nfs/kubernetes *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports

# Start services
systemctl restart bind9 haproxy nfs-kernel-server
systemctl enable bind9 haproxy nfs-kernel-server
exportfs -a

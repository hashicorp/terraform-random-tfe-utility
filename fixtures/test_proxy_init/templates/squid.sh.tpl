#!/bin/bash

set -e -u -o pipefail

echo "[$(date +"%FT%T")] Starting Squid startup script" | tee --append /var/log/ptfe.log

echo "[$(date +"%FT%T")] Sleeping 30 seconds to let the network settle" | tee --append /var/log/ptfe.log
sleep 30

apt-get --yes --option "Acquire::Retries=5" update

echo "[$(date +"%FT%T")] Installing Squid" | tee --append /var/log/ptfe.log
apt-get --assume-yes update
apt-get --assume-yes install squid

echo "[$(date +"%FT%T")] Configuring Squid" | tee --append /var/log/ptfe.log
cat <<EOF > /etc/squid/squid.conf
# https://wiki.squid-cache.org/SquidFaq/ConfiguringSquid#Squid-3.5_default_config

http_port ${http_port}

acl localnet src 10.0.0.0/8     # RFC1918 possible internal network
acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443

acl Safe_ports port 80                    # http
acl Safe_ports port 21                    # ftp
acl Safe_ports port 443                   # https
acl Safe_ports port 70                    # gopher
acl Safe_ports port 210                   # wais
acl Safe_ports port 280                   # http-mgmt
acl Safe_ports port 488                   # gss-http
acl Safe_ports port 591                   # filemaker
acl Safe_ports port 777                   # multiling http
acl Safe_ports port 1025-65535            # unregistered ports
%{ if metrics_endpoint_enabled ~}
acl Safe_ports port ${metrics_http_port}  # metrics-http
acl Safe_ports port ${metrics_https_port} # metrics-https
%{ endif ~}

acl CONNECT method CONNECT

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager

http_access allow localnet
http_access allow localhost
http_access deny all

coredump_dir /squid/var/cache/squid

refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
EOF

echo "[$(date +"%FT%T")] Restarting Squid" | tee --append /var/log/ptfe.log
systemctl restart squid

echo "[$(date +"%FT%T")] Finished Squid startup script" | tee --append /var/log/ptfe.log

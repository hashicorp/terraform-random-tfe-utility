#!/bin/bash

set -e -u -o pipefail

${get_base64_secrets}

echo "[$(date +"%FT%T")] Starting mitmproxy startup script" | tee --append /var/log/ptfe.log
echo "[$(date +"%FT%T")] Install JQ" | tee --append /var/log/ptfe.log
apt-get update -y
apt-get install -y jq
echo "[$(date +"%FT%T")] Installing mitmproxy" | tee --append /var/log/ptfe.log
pushd /tmp
curl --location --remote-name https://snapshots.mitmproxy.org/6.0.2/mitmproxy-6.0.2-linux.tar.gz
tar --extract --file ./mitmproxy*.tar.gz -C /usr/local/bin/
confdir="/etc/mitmproxy"
mkdir --parents $confdir

%{ if ca_certificate_secret != "" && ca_private_key_secret != "" ~}
echo "[$(date +"%FT%T")] Deploying certificates for mitmproxy" | tee --append /var/log/ptfe.log
certificate="$confdir/mitmproxy-ca.pem"

get_base64_secrets ${ca_certificate_secret} \
  | tee $certificate

get_base64_secrets ${ca_private_key_secret} \
  | tee --append $certificate

%{ endif ~}
echo "[$(date +"%FT%T")] Configuring mitmproxy" | tee --append /var/log/ptfe.log
service="/etc/systemd/system/mitmproxy.service"
touch $service
chown root:root $service
chmod 0644 $service

cat <<EOF >$service
[Unit]
Description=mitmproxy
ConditionPathExists=$confdir
[Service]
ExecStart=/usr/local/bin/mitmdump --listen-port ${http_port} --set confdir=$confdir
Restart=always
[Install]
WantedBy=multi-user.target
EOF

echo "[$(date +"%FT%T")] Starting mitmproxy service" | tee --append /var/log/ptfe.log
systemctl daemon-reload
systemctl start mitmproxy
systemctl enable mitmproxy

echo "[$(date +"%FT%T")] Finished mitmproxy startup script" | tee --append /var/log/ptfe.log

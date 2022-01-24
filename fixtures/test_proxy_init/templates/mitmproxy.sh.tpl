#!/bin/bash

set -e -u -o pipefail

echo "[$(date +"%FT%T")] Starting mitmproxy startup script" | tee --append /var/log/ptfe.log

echo "[$(date +"%FT%T")] Installing mitmproxy" | tee --append /var/log/ptfe.log
pushd /tmp
curl --location --remote-name https://snapshots.mitmproxy.org/6.0.2/mitmproxy-6.0.2-linux.tar.gz
tar --extract --file ./mitmproxy*.tar.gz -C /usr/local/bin/
confdir="/etc/mitmproxy"
mkdir --parents $confdir

echo "[$(date +"%FT%T")] Installing jq" | tee --append /var/log/ptfe.log
curl --location --output /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x /usr/local/bin/jq

%{ if ca_certificate_secret != "" && ca_private_key_secret != "" ~}
echo "[$(date +"%FT%T")] Deploying certificates for mitmproxy" | tee --append /var/log/ptfe.log
certificate="$confdir/mitmproxy-ca.pem"
access_token=$(curl http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token \
  | jq -r .access_token)
curl "https://secretmanager.googleapis.com/v1/${ca_certificate_secret}/versions/latest" \
    --header "Authorization: Bearer $access_token" \
    | jq -r .payload.data | base64 --decode | tee $certificate
curl "https://secretmanager.googleapis.com/v1/${ca_private_key_secret}/versions/latest" \
    --header "Authorization: Bearer $access_token" \
    | jq -r .payload.data | base64 --decode | tee --append $certificate
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
ExecStart=/usr/local/bin/mitmdump --port ${http_port} --set confdir=$confdir
Restart=always
[Install]
WantedBy=multi-user.target
EOF

echo "[$(date +"%FT%T")] Starting mitmproxy service" | tee --append /var/log/ptfe.log
systemctl daemon-reload
systemctl start mitmproxy
systemctl enable mitmproxy

echo "[$(date +"%FT%T")] Finished mitmproxy startup script" | tee --append /var/log/ptfe.log

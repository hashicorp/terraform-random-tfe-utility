#!/usr/bin/env bash

set -e -u -o pipefail

${get_base64_secrets}
log_pathname="/var/log/ptfe.log"
tfe_settings_file="ptfe-settings.json"
tfe_settings_path="/etc/$tfe_settings_file"

# -----------------------------------------------------------------------------
# Determine distibution
# -----------------------------------------------------------------------------
echo "[$(date +"%FT%T")] [Terraform Enterprise] Determine distribution" | tee -a $log_pathname
DISTRO_NAME=$(grep "^NAME=" /etc/os-release | cut -d"\"" -f2)

# -----------------------------------------------------------------------------
# Install jq (if not an airgapped environment)
# -----------------------------------------------------------------------------
%{ if airgap_url == null || (airgap_url != null && airgap_pathname != null) ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Install JQ" | tee -a $log_pathname

sudo curl --noproxy '*' -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x /bin/jq
%{ endif ~}


# -----------------------------------------------------------------------------
# Create TFE & Replicated Settings Files
# -----------------------------------------------------------------------------
echo "[$(date +"%FT%T")] [Terraform Enterprise] Create configuration files" | tee -a $log_pathname
sudo echo "${settings}" | sudo base64 -d > $tfe_settings_path
echo "${replicated}" | base64 -d > /etc/replicated.conf

# -----------------------------------------------------------------------------
# Configure the proxy (if applicable)
# -----------------------------------------------------------------------------
%{ if proxy_ip != null ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure proxy" | tee -a $log_pathname

proxy_ip="${proxy_ip}"
proxy_port="${proxy_port}"
/bin/cat <<EOF >>/etc/environment
http_proxy="${proxy_ip}:${proxy_port}"
https_proxy="${proxy_ip}:${proxy_port}"
no_proxy="${no_proxy}"
EOF

/bin/cat <<EOF >/etc/profile.d/proxy.sh
http_proxy="${proxy_ip}:${proxy_port}"
https_proxy="${proxy_ip}:${proxy_port}"
no_proxy="${no_proxy}"
EOF

export http_proxy="${proxy_ip}:${proxy_port}"
export https_proxy="${proxy_ip}:${proxy_port}"
export no_proxy="${no_proxy}"
%{ else ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping proxy configuration" | tee -a $log_pathname
%{ endif ~}

# -----------------------------------------------------------------------------
# Configure TLS (if not an airgapped environment)
# -----------------------------------------------------------------------------
%{ if certificate_secret != null ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure TlsBootstrapCert" | tee -a $log_pathname
certificate_data_b64=$(get_base64_secrets ${certificate_secret.id})
mkdir -p $(dirname ${tls_bootstrap_cert_pathname})
echo $certificate_data_b64 | base64 --decode > ${tls_bootstrap_cert_pathname}
%{ else ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping TlsBootstrapCert configuration" | tee -a $log_pathname
%{ endif ~}

%{ if key_secret != null ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure TlsBootstrapKey" | tee -a $log_pathname
key_data_b64=$(get_base64_secrets ${key_secret.id})
mkdir -p $(dirname ${tls_bootstrap_key_pathname})
echo $key_data_b64 | base64 --decode > ${tls_bootstrap_key_pathname}
chmod 0600 ${tls_bootstrap_key_pathname}

%{ else ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping TlsBootstrapKey configuration" | tee -a $log_pathname
%{ endif ~}

#------------------------------------------------------------------------------
# Configure CA Certificate (if not an airgapped environment)
#------------------------------------------------------------------------------
ca_certificate_directory="/dev/null"

if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
	ca_certificate_directory=/usr/share/pki/ca-trust-source/anchors
else
	ca_certificate_directory=/usr/local/share/ca-certificates/extra
fi
ca_cert_filepath="$ca_certificate_directory/tfe-ca-certificate.crt"

%{ if ca_certificate_secret != null ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure CA cert" | tee -a $log_pathname
ca_certificate_data_b64=$(get_base64_secrets ${ca_certificate_secret.id})

mkdir -p $ca_certificate_directory
echo $ca_certificate_data_b64 | base64 --decode > $ca_cert_filepath
%{ else ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping CA certificate configuration" | tee -a $log_pathname
%{ endif ~}

if [ -f "$ca_cert_filepath" ]
then
	if [[ $DISTRO_NAME == *"Red Hat"* ]]
	then
		update-ca-trust
	else
		update-ca-certificates
	fi
	
	jq ". + { ca_certs: { value: \"$(/bin/cat $ca_cert_filepath)\" } }" -- $tfe_settings_path > $tfe_settings_file.updated
	cp ./$tfe_settings_file.updated $tfe_settings_path
fi

# -----------------------------------------------------------------------------
# Resize RHEL logical volume (if Azure environment)
# -----------------------------------------------------------------------------
%{ if cloud == "azurerm" ~}
if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
echo "[$(date +"%FT%T")] [Terraform Enterprise] Resize RHEL logical volume" | tee -a $log_pathname

# Because Microsoft is publishing only LVM-partitioned images, it is necessary to partition it to the specs that TFE requires.
# First, extend the partition to fill available space
growpart /dev/disk/azure/root 4
# Resize the physical volume
pvresize /dev/disk/azure/root-part4
# Then resize the logical volumes to meet TFE specs
lvresize -r -L 10G /dev/mapper/rootvg-rootlv
lvresize -r -L 40G /dev/mapper/rootvg-varlv
fi
%{ endif ~}

# -----------------------------------------------------------------------------
# Retrieve TFE license (if not an airgapped environment)
# -----------------------------------------------------------------------------
%{ if tfe_license_secret != null ~}
echo "[$(date +"%FT%T")] [Terraform Enterprise] Retrieve TFE license" | tee -a $log_pathname
license=$(get_base64_secrets ${tfe_license_secret.id})
echo $license | base64 -d > ${tfe_license_file_location}
%{ endif ~}

# -----------------------------------------------------------------------------
# Download Replicated
# -----------------------------------------------------------------------------
replicated_directory="/etc/replicated"

%{ if airgap_url != null && airgap_pathname != null ~}
# Bootstrap airgapped environment with prerequisites (for dev/test environments)
echo "[Terraform Enterprise] Installing Docker Engine from Repository for Bootstrapping an Airgapped Installation" | tee -a $log_pathname

if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
yum install --assumeyes yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install --assumeyes docker-ce docker-ce-cli containerd.io
else
apt-get --assume-yes update
apt-get --assume-yes install \
	ca-certificates \
	curl \
	gnupg \
	lsb-release
curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg \
	| gpg --dearmor --output /usr/share/keyrings/docker-archive-keyring.gpg
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
	https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable" \
	| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get --assume-yes update
apt-get --assume-yes install docker-ce docker-ce-cli containerd.io
apt-get --assume-yes autoremove
fi

replicated_filename="replicated.tar.gz"
replicated_url="https://s3.amazonaws.com/replicated-airgap-work/$replicated_filename"
replicated_pathname="$replicated_directory/$replicated_filename"

echo "[Terraform Enterprise] Downloading Replicated from '$replicated_url' to '$replicated_pathname'" | tee -a $log_pathname
curl --create-dirs --output "$replicated_pathname" "$replicated_url"
echo "[Terraform Enterprise] Extracting Replicated in '$replicated_directory'" | tee -a $log_pathname
tar --directory "$replicated_directory" --extract --file "$replicated_pathname"

echo "[Terraform Enterprise] Copying airgap package '${airgap_url}' to '${airgap_pathname}'" | tee -a $log_pathname
curl --create-dirs --output "${airgap_pathname}" "${airgap_url}"
%{ endif ~}

# -----------------------------------------------------------------------------
# Install Terraform Enterprise
# -----------------------------------------------------------------------------
echo "[$(date +"%FT%T")] [Terraform Enterprise] Install TFE" | tee -a $log_pathname
instance_ip=$(hostname -i)
install_pathname="$replicated_directory/install.sh"

%{ if airgap_pathname == null ~}
curl --create-dirs --output $install_pathname https://get.replicated.com/docker/terraformenterprise/active-active
%{ endif ~}

chmod +x $install_pathname
cd $replicated_directory
$install_pathname \
	bypass-firewalld-warning \
	%{ if proxy_ip != null ~}
	http-proxy="${proxy_ip}:${proxy_port}" \
	additional-no-proxy="${no_proxy}" \
	%{ else ~}
	no-proxy \
	%{ endif ~}
	%{if active_active ~}
	disable-replicated-ui \
	%{ endif ~}
	private-address=$instance_ip \
	public-address=$instance_ip \
	%{ if airgap_pathname != null ~}
	airgap \
	%{ endif ~}
	| tee -a $log_pathname

# -----------------------------------------------------------------------------
# Add docker0 to firewalld (for Red Hat instances only)
# -----------------------------------------------------------------------------
if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Disable SELinux (temporary)" | tee -a $log_pathname
	setenforce 0
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Add docker0 to firewalld" | tee -a $log_pathname
	firewall-cmd --permanent --zone=trusted --change-interface=docker0
	firewall-cmd --reload
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Enable SELinux" | tee -a $log_pathname
	setenforce 1
fi

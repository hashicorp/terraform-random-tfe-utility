# General
# -------
variable "is_legacy_deployment" {
  type        = bool
  description = "TFE will be installed using a Replicated license and deployment method."
  default     = true # This will default to null after FDO is GA.
}

variable "cloud" {
  default     = null
  type        = string
  description = "(Required) On which cloud is this Terraform Enterprise installation being deployed?"
  validation {
    condition     = contains(["aws", "azurerm", "google"], var.cloud)
    error_message = "Supported values for cloud are 'aws', 'azurerm', or 'google'."
  }
}

variable "distribution" {
  default     = null
  type        = string
  description = "(Required) What is the OS distribution of the instance on which Terraoform Enterprise will be deployed?"
  validation {
    condition     = contains(["rhel", "ubuntu"], var.distribution)
    error_message = "Supported values for distribution are 'rhel', or 'ubuntu'."
  }
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The secrets manager secret ID under which the Base64 encoded Terraform Enterprise license is stored. NOTE: If this is an airgapped installation, then it is expected that the TFE license will be put on the path defined by tfe_license_file_location prior to running this module (i.e. on the virtual machine image)."
}

variable "airgap_url" {
  default     = null
  description = "The URL of a Replicated airgap package for Terraform Enterprise. NOTE: If this value is given, then this script will install the airgap installation prerequisites. The airgap bundle should already be on the virtual machine image, and you would not use this variable if this were a truly airgapped environment." 
  type        = string
}

variable "ca_certificate_secret_id" {
  default     = null
  type        = string
  description = "A secret ID which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the TFE instance(s)."
}

variable "certificate_secret_id" {
  default     = null
  type        = string
  description = "A secret ID which contains the Base64 encoded version of a PEM encoded public certificate for the TFE instance(s)."
}

variable "key_secret_id" {
  default     = null
  type        = string
  description = "A secret ID which contains the Base64 encoded version of a PEM encoded private key for the TFE instance(s)."
}

# Proxy
# -----
variable "proxy_ip" {
  default     = null
  type        = string
  description = "IP Address of the proxy server"
}

variable "proxy_port" {
  default     = null
  type        = string
  description = "Port that the proxy server will use"
}

variable "tfe_configuration" {
  default     = null
  description = "The settings that will be used to configure Terraform Enterprise."
}

variable "enable_monitoring" {
  default     = null
  type        = bool
  description = "Should cloud appropriate monitoring agents be installed as a part of the TFE installation script?"
}

# Mounted Disk
# ------------
variable "disk_device_name" {
  default     = null
  description = "The name of the disk device on which Terraform Enterprise will store data in Mounted Disk mode."
  type        = string
}

variable "disk_path" {
  default     = null
  description = "The pathname of the directory in which Terraform Enterprise will store data in Mounted Disk mode."
  type        = string
}

# Flexible Deployment Options Settings
# ------------------------------------
variable "registry_username" {
  default     = null
  description = "The username for the docker registry to source terraform_enterprise_next container images from"
  type        = string
}

variable "registry_password" {
  default     = null
  description = "The password for the docker registry to source terraform_enterprise_next container images from"
  type        = string
}

variable "docker_compose_yaml" {
  default     = null
  description = "The yaml encoded contents of what make up a docker compose file, to be run with docker compose in the user data script"
  type        = string
}

variable "operational_mode" {
  default     = null
  description = "A special string to control the operational mode of Terraform Enterprise. Valid values are: 'external' for External Services mode; 'disk' for Mounted Disk mode; 'active-active' for Active/Active mode."
}

variable "custom_image_tag" {
  default     = null
  type        = string
  description = "(Required if tbw_image is 'custom_image'.) The name and tag for your alternative Terraform build worker image in the format <name>:<tag>. Default is 'hashicorp/build-worker:now'. If this variable is used, the 'tbw_image' variable must be 'custom_image'."
}

variable "extra_no_proxy" {
  default     = null
  type        = list(string)
  description = "When configured to use a proxy, a list of hosts to exclude from proxying. Please note that this list does not support whitespace characters."
}

# Legacy Settings
# ---------------
variable "replicated_configuration" {
  default     = null
  description = "The settings that will be used to configure Replicated."
}
# General
# -------
variable "cloud" {
  type        = string
  description = "(Required) On which cloud is this Terraoform Enterprise installation being deployed?"
  validation {
    condition = (
      var.cloud == "aws" ||
      var.cloud == "azurerm" ||
      var.cloud == "google"
    )

    error_message = "Supported values for cloud are 'aws', 'azurerm', or 'google'."
  }
}

variable "tfe_license_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  The secrets manager secret name under which the Base64 encoded Terraform Enterprise license is stored.
  NOTE: If this is an airgapped installation, then it is expected that the TFE license will be put
  on the path defined by tfe_license_file_location prior to running this module (i.e. on the virtual machine
  image).
  EOD
}

variable "airgap_url" {
  description = <<-EOD
  The URL of a Replicated airgap package for Terraform Enterprise.
  NOTE: If this value is given, then this script will install the airgap installation prerequisites. The airgap
  bundle should already be on the virtual machine image, and you would not use this variable if this were a truly
  airgapped environment.
  EOD 
  type        = string
}

variable "ca_certificate_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate
  authority (CA) to be trusted by the TFE instance(s).
  EOD
}

variable "certificate_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A secret which contains the Base64 encoded version of a PEM encoded public certificate for the TFE
  instance(s).
  EOD
}

variable "key_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A secret which contains the Base64 encoded version of a PEM encoded private key for the TFE
  instance(s).
  EOD
}

# Proxy
# -----
variable "proxy_ip" {
  type        = string
  description = "IP Address of the proxy server"
}

variable "proxy_port" {
  default     = "3128"
  type        = string
  description = "Port that the proxy server will use"
}

# Settings
# --------
variable "replicated_configuration" {
  description = "The settings that will be used to configure Replicated."
}

variable "tfe_configuration" {
  description = "The settings that will be used to configure Terraform Enterprise."
}
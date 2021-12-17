# General
# -------
variable "fqdn" {
  type        = string
  description = "The fully qualified domain name for the TFE environment"
}

variable "active_active" {
  type        = bool
  description = "True if TFE running in active-active configuration"
}

variable "tfe_license_secret" {
  type = object({
    id = string
  })
  description = "The Key Vault secret under which the Base64 encoded Terraform Enterprise license is stored."
}

variable "ca_certificate_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate
  authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "certificate_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual
  Machine Scale Set.
  EOD
}

variable "key_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine
  Scale Set.
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

variable "no_proxy" {
  default     = []
  type        = list(string)
  description = "Addresses which should not be accessed through the proxy server located at proxy_ip. This list will be combined with internal GCP addresses."
}



variable "replicated_configuration" {}
variable "tfe_configuration" {}
variable "tls_bootstrap_cert_pathname" {}
variable "tls_bootstrap_key_pathname" {}
variable "tfe_license_pathname" {}
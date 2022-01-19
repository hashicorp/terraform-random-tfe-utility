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
  description = "The secrets manager secret name under which the Base64 encoded Terraform Enterprise license is stored."
}

variable "tfe_license_file_location" {
  default     = "/etc/terraform-enterprise.rli"
  type        = string
  description = "The path on the TFE instance to put the TFE license."
}

variable "tls_bootstrap_cert_pathname" {
  default     = "/var/lib/terraform-enterprise/certificate.pem"
  type        = string
  description = "The path on the TFE instance to put the certificate."
}

variable "tls_bootstrap_key_pathname" {
  default     = "/var/lib/terraform-enterprise/key.pem"
  type        = string
  description = "The path on the TFE instance to put the key."
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
  instance(s)
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

# Settings
# --------
variable "replicated_configuration" {
  description = "The settings that will be used to configure Replicated."
}

variable "tfe_configuration" {
  description = "The settings that will be used to configure Terraform Enterprise."
}
# General
# -------
variable "tfe_license_secret" {
  type = object({
    id = string
  })
  description = "The secrets manager secret name under which the Base64 encoded Terraform Enterprise license is stored."
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

# Settings
# --------
variable "replicated_configuration" {
  description = "The settings that will be used to configure Replicated."
}

variable "tfe_configuration" {
  description = "The settings that will be used to configure Terraform Enterprise."
}
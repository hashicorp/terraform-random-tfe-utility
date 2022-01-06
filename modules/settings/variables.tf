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

# Database
# --------
variable "postgres" {
  type = map(any)
}

# Redis
# -----
variable "redis_settings" {
  type = map(any)
}

# Azure
# -----
variable "user_data_azure_container_name" {
  type        = string
  description = "Azure storage container name"
}

variable "user_data_azure_account_key" {
  type        = string
  description = "Azure storage account key"
}

variable "user_data_azure_account_name" {
  type        = string
  description = "Azure storage account name"
}

# TFE
# ---
variable "release_sequence" {
  type        = string
  description = "Terraform Enterprise version release sequence"
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

variable "iact_subnet_list" {
  default     = []
  type        = list(string)
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
}

variable "user_data_installation_type" {
  type        = string
  description = "Installation type for Terraform Enterprise"

  validation {
    condition = (
      var.user_data_installation_type == "poc" ||
      var.user_data_installation_type == "production"
    )

    error_message = "The installation type must be 'production' (recommended) or 'poc' (only used for demo-mode)."
  }
}

variable "user_data_trusted_proxies" {
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like
  those made to the IACT endpoint.
  EOD
  type        = list(string)
}

variable "tfe_license_pathname" {}
variable "tls_bootstrap_cert_pathname" {}
variable "tls_bootstrap_key_pathname" {}

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

variable "metrics_endpoint_enabled" {
  default     = null
  type        = bool
  description = <<-EOD
  (Optional) Metrics are used to understand the behavior of Terraform Enterprise and to
  troubleshoot and tune performance. Enable an endpoint to expose container metrics.
  Defaults to false.
  EOD
}

variable "metrics_endpoint_port_http" {
  default     = null
  type        = number
  description = <<-EOD
  (Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTP metrics
  requests will be handled.
  Defaults to 9090.
  EOD
}

variable "metrics_endpoint_port_https" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTPS metrics
  requests will be handled.
  Defaults to 9091.
  EOD
}

variable "mitmproxy_ca_certificate_secret" {
  default     = null
  description = <<-EOD
  The identifier of a secret comprising a Base64 encoded PEM certificate file for the mitmproxy Certificate Authority.
  For GCP, the Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "mitmproxy_ca_private_key_secret" {
  default     = null
  description = <<-EOD
  The identifier of a secret comprising a Base64 encoded PEM private key file for the mitmproxy Certificate Authority.
  For GCP, the Terraform provider calls this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

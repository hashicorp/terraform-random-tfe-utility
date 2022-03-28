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

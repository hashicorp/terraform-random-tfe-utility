# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# SSH Config
# ----------
variable "tfe_instance_ip_addresses" {
  default     = null
  type        = list(string)
  description = "The internal IP address of the TFE instance."
}

variable "tfe_instance_user_name" {
  default     = null
  type        = string
  description = "The username of the TFE instance."
}

variable "tfe_private_key_path" {
  default     = null
  type        = string
  description = "The private SSH key."
}

variable "tfe_private_key_data_base64" {
  default     = null
  type        = string
  description = "The SSH private key data to use on the bastion VM in order to SSH to the TFE instance."
}

variable "tfe_ssh_config_path" {
  default     = null
  type        = string
  description = "The path to put the ssh-config file for the TFE instance. This will be iterated based on how many instances there are."
}

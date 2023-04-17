# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "custom_data_setup_ssh" {
  value       = base64encode(local.setup_ssh)
  description = "A Base64 encoded, rendered template of the cloud-init script that will allow for SSH to the TFE instance."
}
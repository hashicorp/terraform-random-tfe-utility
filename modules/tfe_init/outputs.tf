# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "tfe_userdata_base64_encoded" {
  value       = var.is_legacy_deployment ? (local.tfe_legacy_user_data) : local.tfe_user_data
  description = "The Base64 encoded TFE init script built from modules/tfe_init/templates/tfe.sh.tpl"
}

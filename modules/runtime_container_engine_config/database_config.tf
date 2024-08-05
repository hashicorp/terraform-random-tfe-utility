# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  database = {
    TFE_DATABASE_USER                  = var.database_user
    TFE_DATABASE_PASSWORD              = var.database_password
    TFE_DATABASE_HOST                  = var.database_host
    TFE_DATABASE_NAME                  = var.database_name
    TFE_DATABASE_PARAMETERS            = var.database_parameters
    TFE_DATABASE_RECONNECT_ENABLED     = var.database_reconnect_enabled
    TFE_DATABASE_RECONNECT_MAX_RETRIES = var.database_reconnect_max_retries
    TFE_DATABASE_RECONNECT_INTERVAL    = var.database_reconnect_interval
  }
  database_configuration = local.disk ? {} : local.database
}

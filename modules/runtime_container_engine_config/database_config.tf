# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  database = {
    TFE_DATABASE_USER       = var.database_user
    TFE_DATABASE_PASSWORD   = replace(var.database_password, "$", "\\$\\$")
    TFE_DATABASE_HOST       = var.database_host
    TFE_DATABASE_NAME       = var.database_name
    TFE_DATABASE_PARAMETERS = var.database_parameters
  }
  database_configuration = local.disk ? {} : local.database
}

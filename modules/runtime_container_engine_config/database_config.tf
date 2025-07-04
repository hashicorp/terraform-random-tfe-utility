# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  database = {
    TFE_DATABASE_USER                         = var.database_user
    TFE_DATABASE_PASSWORD                     = var.database_password
    TFE_DATABASE_HOST                         = var.database_host
    TFE_DATABASE_NAME                         = var.database_name
    TFE_DATABASE_PARAMETERS                   = var.database_parameters
    TFE_DATABASE_USE_MTLS                     = var.database_use_mtls
    TFE_DATABASE_CA_CERT_FILE                 = var.database_ca_cert_file
    TFE_DATABASE_CLIENT_CERT_FILE             = var.database_client_cert_file
    TFE_DATABASE_CLIENT_KEY_FILE              = var.database_client_key_file
    TFE_DATABASE_PASSWORDLESS_AZURE_USE_MSI   = var.database_passwordless_azure_use_msi
    TFE_DATABASE_PASSWORDLESS_AZURE_CLIENT_ID = var.database_passwordless_azure_client_id
  }
  database_configuration = local.disk ? {} : local.database
}

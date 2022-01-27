locals {
  external_azure_configs = {
    azure_account_name = {
      value = var.azure_account_name
    }

    azure_account_key = {
      value = var.azure_account_key
    }

    azure_container = {
      value = var.azure_container
    }

    azure_endpoint = {
      value = var.azure_endpoint
    }
  }
}

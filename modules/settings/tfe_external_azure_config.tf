locals {
  external_azure_configs = {
    azure_account_name = {
      value = var.user_data_azure_account_name
    }

    azure_account_key = {
      value = var.user_data_azure_account_key
    }

    azure_container = {
      value = var.user_data_azure_container_name
    }

    placement = {
      value = var.user_data_installation_type == "poc" ? null : "placement_azure"
    }
  }
}

locals {
  pg_configs = {
    enable_active_active = {
      value = var.enable_active_active == true ? "1" : var.enable_active_active == false ? "0" : null
    }

    pg_dbname = {
      value = var.pg_dbname
    }

    pg_netloc = {
      value = var.pg_netloc
    }

    pg_password = {
      value = var.pg_password
    }

    pg_user = {
      value = var.pg_user
    }

    log_forwarding_config = {
      value = var.log_forwarding_config
    }

    log_forwarding_enabled = {
      value = var.log_forwarding_enabled == true ? "1" : var.log_forwarding_enabled == false ? "0" : null
    }

  }

  pg_optional_configs = {
    pg_extra_params = {
      value = var.pg_extra_params
    }
  }

  base_external_configs = local.pg_optional_configs == null ? local.pg_configs : (merge(local.pg_configs, local.pg_optional_configs))
}
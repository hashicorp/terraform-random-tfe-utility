locals {
  pg_configs = {
    enable_active_active = {
      value = var.active_active ? "1" : "0"
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
  }

  pg_optional_configs = {
    pg_extra_params = {
      value = var.pg_extra_params
    }
  }

  base_external_configs = local.pg_optional_configs == null ? local.pg_configs : (merge(local.pg_configs, local.pg_optional_configs))
}
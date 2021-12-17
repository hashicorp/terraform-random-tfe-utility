locals {
  base_external_configs = {
    enable_active_active = {
      value = var.active_active ? "1" : "0"
    }

    pg_dbname = {
      value = var.postgres.dbname
    }

    pg_netloc = {
      value = var.postgres.netloc
    }

    pg_password = {
      value = var.postgres.password
    }

    pg_user = {
      value = var.postgres.user
    }
  }
}
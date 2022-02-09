locals {
  redis_configs = {
    redis_host = {
      value = var.redis_host
    }

    redis_port = {
      value = var.redis_use_tls == true ? "6380" : var.redis_use_tls == false ? "6379" : null
    }

    redis_use_password_auth = {
      value = var.redis_use_password_auth == true ? "1" : var.redis_use_password_auth == false ? "0" : null
    }

    redis_pass = {
      value = var.redis_pass
    }

    redis_use_tls = {
      value = var.redis_use_tls == true ? "1" : var.redis_use_tls == false ? "0" : null
    }
  }

  redis_configuration = var.enable_active_active ? local.redis_configs : {}
}

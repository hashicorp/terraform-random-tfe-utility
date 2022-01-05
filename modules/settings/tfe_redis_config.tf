locals {
  redis_configs = {
    redis_host = {
      value = var.redis_settings.host
    }

    redis_pass = {
      value = var.redis_settings.pass
    }

    redis_port = {
      value = var.redis_settings.enable_non_ssl_port == "true" ? "6379" : "6380"
    }

    redis_use_password_auth = {
      value = var.redis_settings.enable_authentication == "true" ? "1" : "0"
    }

    redis_use_tls = {
      value = var.redis_settings.use_tls == "true" ? "1" : "0"
    }
  }

  redis_configuration = var.active_active ? local.redis_configs : {}
}

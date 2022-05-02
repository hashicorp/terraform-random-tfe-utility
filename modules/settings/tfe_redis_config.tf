locals {
  redis_configs = {
    redis_host = {
      value = var.redis_host
    }

    redis_port = {
      value = var.redis_port != null ? tostring(var.redis_port) : var.redis_use_tls != null ? var.redis_use_tls ? "6380" : "6379" : null
    }

    redis_use_password_auth = {
      value = var.redis_use_password_auth != null ? var.redis_use_password_auth ? "1" : "0" : null
    }

    redis_pass = {
      value = var.redis_pass
    }

    redis_use_tls = {
      value = var.redis_use_tls != null ? var.redis_use_tls ? "1" : "0" : null
    }
  }

  redis_configuration = var.enable_active_active ? local.redis_configs : {}
}

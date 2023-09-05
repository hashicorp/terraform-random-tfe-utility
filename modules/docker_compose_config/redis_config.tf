locals {
  redis = {
    TFE_REDIS_HOST     = var.redis_host
    TFE_REDIS_USER     = var.redis_user
    TFE_REDIS_PASSWORD = var.redis_password
    TFE_REDIS_USE_TLS  = var.redis_use_tls
    TFE_REDIS_USE_AUTH = var.redis_use_auth
  }
  redis_configuration = local.active_active ? local.redis : {}
}
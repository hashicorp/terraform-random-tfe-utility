# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  redis = {
    TFE_REDIS_HOST     = var.redis_use_tls != null ? var.redis_use_tls ? "${var.redis_host}:6380" : var.redis_host : null
    TFE_REDIS_USER     = var.redis_user
    TFE_REDIS_PASSWORD = var.redis_password
    TFE_REDIS_USE_TLS  = var.redis_use_tls
    TFE_REDIS_USE_AUTH = var.redis_use_auth
  }
  redis_configuration = local.active_active ? local.redis : {}
}
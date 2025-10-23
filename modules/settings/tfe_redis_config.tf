# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  redis_configs = {
    redis_host = {
      value = var.redis_host
    }

    redis_port = {
      value = var.redis_use_tls != null ? var.redis_use_tls ? "6380" : "6379" : null
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

    redis_use_mtls = {
      value = var.redis_use_mtls != null ? var.redis_use_mtls ? "1" : "0" : null
    }

    # Redis AWS IAM authentication
    redis_passwordless_aws_use_iam = {
      value = var.redis_passwordless_aws_use_iam != null ? var.redis_passwordless_aws_use_iam ? "1" : "0" : null
    }

    redis_passwordless_aws_region = {
      value = var.redis_passwordless_aws_region
    }

    redis_passwordless_aws_service_name = {
      value = var.redis_passwordless_aws_service_name
    }

    redis_passwordless_aws_host_name = {
      value = var.redis_passwordless_aws_host_name
    }
  }

  redis_configuration = var.production_type == "active-active" ? local.redis_configs : {}
}

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "docker_compose_yaml" {
  value       = base64encode(yamlencode(local.compose))
  description = "A base 64 encoded yaml object that will be used as the Docker Compose file for TFE deployment."
}

output "podman_kube_yaml" {
  value       = base64encode(yamlencode(local.kube))
  description = "A base 64 encoded yaml object that will be used as the Podman kube.yaml file for TFE deployment"
}

# DEBUG: Redis environment variables debug
output "debug_redis_env_vars" {
  description = "DEBUG: All Redis environment variables being set in TFE container"
  value = {
    TFE_REDIS_HOST                               = local.redis.TFE_REDIS_HOST
    TFE_REDIS_USER                               = local.redis.TFE_REDIS_USER
    TFE_REDIS_PASSWORD                           = local.redis.TFE_REDIS_PASSWORD != null ? "SET" : "NULL"
    TFE_REDIS_USE_TLS                            = local.redis.TFE_REDIS_USE_TLS
    TFE_REDIS_USE_AUTH                           = local.redis.TFE_REDIS_USE_AUTH
    TFE_REDIS_PASSWORDLESS_AWS_USE_IAM           = local.redis.TFE_REDIS_PASSWORDLESS_AWS_USE_IAM
    TFE_REDIS_PASSWORDLESS_AWS_REGION            = local.redis.TFE_REDIS_PASSWORDLESS_AWS_REGION
    TFE_REDIS_PASSWORDLESS_AWS_HOST_NAME         = local.redis.TFE_REDIS_PASSWORDLESS_AWS_HOST_NAME
    TFE_REDIS_PASSWORDLESS_AWS_USE_INSTANCE_PROFILE = local.redis.TFE_REDIS_PASSWORDLESS_AWS_USE_INSTANCE_PROFILE
  }
}

output "debug_redis_input_vars" {
  description = "DEBUG: Input variables received by terraform-random-tfe-utility"
  value = {
    redis_user                           = var.redis_user
    redis_host                           = var.redis_host
    redis_use_tls                        = var.redis_use_tls
    redis_passwordless_aws_use_iam       = var.redis_passwordless_aws_use_iam
    redis_passwordless_aws_region        = var.redis_passwordless_aws_region
    redis_passwordless_aws_host_name     = var.redis_passwordless_aws_host_name
  }
}

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

output "debug_redis_env_vars" {
  value = {
    TFE_REDIS_USER                           = local.redis.TFE_REDIS_USER
    TFE_REDIS_USE_AUTH                       = local.redis.TFE_REDIS_USE_AUTH
    TFE_REDIS_USE_TLS                        = local.redis.TFE_REDIS_USE_TLS
    TFE_REDIS_PASSWORDLESS_AWS_USE_IAM       = local.redis.TFE_REDIS_PASSWORDLESS_AWS_USE_IAM
    TFE_REDIS_SIDEKIQ_PASSWORDLESS_AWS_USE_IAM = local.redis.TFE_REDIS_SIDEKIQ_PASSWORDLESS_AWS_USE_IAM
    TFE_REDIS_CA_CERT_PATH                   = local.redis.TFE_REDIS_CA_CERT_PATH
  }
  description = "Debug output for Redis environment variables"
}

output "debug_redis_input_vars" {
  value = {
    redis_user                      = var.redis_user
    redis_use_auth                  = var.redis_use_auth
    redis_use_tls                   = var.redis_use_tls
    redis_passwordless_aws_use_iam  = var.redis_passwordless_aws_use_iam
    redis_ca_cert_path              = var.redis_ca_cert_path
  }
  description = "Debug output for Redis input variables"
}

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "docker_compose_yaml" {
  value       = yamlencode(local.compose)
  description = "A yaml object that will be used as the Docker Compose file for TFE deployment."
}

output "podman_kube_yaml" {
  value       = yamlencode(local.kube)
  description = "A yaml object that will be used as the Podman kube.yaml file for TFE deployment"
}

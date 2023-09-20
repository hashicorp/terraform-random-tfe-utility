# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "docker_compose_yaml" {
  value = yamlencode(local.compose)
  description = "A yaml object that will be used as the Docker Compose file for TFE deployment."
}

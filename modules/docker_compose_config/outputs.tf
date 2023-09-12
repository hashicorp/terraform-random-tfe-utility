# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "docker_compose_yaml" {
  value = yamlencode(local.compose)
}

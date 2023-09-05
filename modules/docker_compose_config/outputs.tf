output "docker_compose_yaml" {
  value = yamlencode(local.compose)
}

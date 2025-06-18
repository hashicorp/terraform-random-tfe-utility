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

output "database_host" {
  value       = var.database_host
  description = "The PostgreSQL server to connect to in the format HOST[:PORT] (e.g. db.example.com or db.example.com:5432). If only HOST is provided then the :PORT defaults to :5432 if no value is given. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

output "database_name" {
  value       = var.database_name
  description = "Name of the PostgreSQL database to store application data in. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

output "database_parameters" {
  value       = var.database_parameters
  description = "PostgreSQL server parameters for the connection URI. Used to configure the PostgreSQL connection (e.g. sslmode=require)."
}

output "database_password" {
  value       = var.database_password
  description = "PostgreSQL password. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

output "database_user" {
  value       = var.database_user
  description = "PostgreSQL password. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

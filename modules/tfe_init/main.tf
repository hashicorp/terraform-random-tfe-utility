# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {

  tls_bootstrap_path          = "/etc/tfe/ssl"
  tls_bootstrap_cert_pathname = "${local.tls_bootstrap_path}/cert.pem"
  tls_bootstrap_key_pathname  = "${local.tls_bootstrap_path}/key.pem"
  tls_bootstrap_ca_pathname   = "${local.tls_bootstrap_path}/bundle.pem"

  tfe_user_data = templatefile(
    "${path.module}/templates/tfe.sh.tpl",
    {
      get_base64_secrets        = local.get_base64_secrets
      install_packages          = local.install_packages
      install_monitoring_agents = local.install_monitoring_agents

      active_active               = var.operational_mode == "active-active"
      cloud                       = var.cloud
      custom_image_tag            = try(var.custom_image_tag, null)
      disk_path                   = var.disk_path
      disk_device_name            = var.disk_device_name
      distribution                = var.distribution
      docker_config               = filebase64("${path.module}/files/daemon.json")
      docker_version              = var.distribution == "rhel" ? var.docker_version_rhel : null
      enable_monitoring           = var.enable_monitoring != null ? var.enable_monitoring : false
      tls_bootstrap_cert_pathname = local.tls_bootstrap_cert_pathname
      tls_bootstrap_key_pathname  = local.tls_bootstrap_key_pathname
      tls_bootstrap_ca_pathname   = local.tls_bootstrap_ca_pathname
      compose                     = var.docker_compose_yaml

      ca_certificate_secret_id = var.ca_certificate_secret_id
      certificate_secret_id    = var.certificate_secret_id
      key_secret_id            = var.key_secret_id

      proxy_ip   = var.proxy_ip
      proxy_port = var.proxy_port
      no_proxy   = var.extra_no_proxy != null ? join(",", var.extra_no_proxy) : null

      registry_username = var.registry_username
      registry_password = var.registry_password
  })
}

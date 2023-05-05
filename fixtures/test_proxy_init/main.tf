# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  mitmproxy_http_port = 3128
  mitmproxy_user_data_script = templatefile(
    "${path.module}/templates/mitmproxy.sh.tpl",
    {
      get_base64_secrets       = local.get_base64_secrets
      install_packages         = local.install_packages
      ca_certificate_secret    = var.mitmproxy_ca_certificate_secret != null ? var.mitmproxy_ca_certificate_secret : ""
      ca_private_key_secret    = var.mitmproxy_ca_private_key_secret != null ? var.mitmproxy_ca_private_key_secret : ""
      http_port                = local.mitmproxy_http_port
      metrics_endpoint_enabled = var.metrics_endpoint_enabled != null ? var.metrics_endpoint_enabled : false
      metrics_http_port        = var.metrics_endpoint_port_http != null ? tostring(var.metrics_endpoint_port_http) : "9090"
      metrics_https_port       = var.metrics_endpoint_port_https != null ? tostring(var.metrics_endpoint_port_https) : "9091"
      cloud                    = var.cloud
    }
  )

  squid_http_port = 3128
  squid_user_data_script = templatefile(
    "${path.module}/templates/squid.sh.tpl",
    {
      http_port                = local.squid_http_port
      metrics_endpoint_enabled = var.metrics_endpoint_enabled != null ? var.metrics_endpoint_enabled : false
      metrics_http_port        = var.metrics_endpoint_port_http != null ? tostring(var.metrics_endpoint_port_http) : "9090"
      metrics_https_port       = var.metrics_endpoint_port_https != null ? tostring(var.metrics_endpoint_port_https) : "9091"
    }
  )

  get_base64_secrets = templatefile("${path.module}/templates/get_base64_secrets.func", {
    cloud = var.cloud
  })

  install_packages = templatefile("${path.module}/templates/install_packages.func", {
    cloud = var.cloud
  })
}

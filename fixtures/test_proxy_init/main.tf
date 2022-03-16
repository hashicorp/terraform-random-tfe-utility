locals {
  mitmproxy_http_port = 8080
  mitmproxy_user_data_script = templatefile(
    "${path.module}/templates/mitmproxy.sh.tpl",
    {
      get_base64_secrets    = data.template_file.get_base64_secrets.rendered
      ca_certificate_secret = var.mitmproxy_ca_certificate_secret != null ? var.mitmproxy_ca_certificate_secret : ""
      ca_private_key_secret = var.mitmproxy_ca_private_key_secret != null ? var.mitmproxy_ca_private_key_secret : ""
      http_port             = local.mitmproxy_http_port
    }
  )

  squid_http_port = 3128
  squid_user_data_script = templatefile(
    "${path.module}/templates/squid.sh.tpl",
    { http_port = local.squid_http_port }
  )
}

data "template_file" "get_base64_secrets" {
  template = file("${path.module}/templates/get_base64_secrets.func")

  vars = {
    cloud = var.cloud
  }
}

output "mitmproxy" {
  value = {
    http_port        = local.mitmproxy_http_port
    user_data_script = local.mitmproxy_user_data_script
  }

  description = "The HTTP port and user data shell script for an mitmproxy installation."
}

output "squid" {
  value = {
    http_port        = local.squid_http_port
    user_data_script = local.squid_user_data_script
  }

  description = "The HTTP port and user data shell script for a Squid installation."
}

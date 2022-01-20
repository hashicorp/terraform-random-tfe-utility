output "mitmproxy" {
  value = {
    http_port                       = local.mitmproxy_http_port
    user_data_script_base64_encoded = local.mitmproxy_user_data_script_base64_encoded
  }

  description = "The HTTP port and user data shell script for an mitmproxy installation."
}

output "squid" {
  value = {
    http_port = local.squid_http_port
    user_data_script_base64_encoded = local.squid_user_data_script_base64_encoded
  }

  description = "The HTTP port and user data shell script for a Squid installation."
}

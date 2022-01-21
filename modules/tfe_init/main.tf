locals {
  # Build TFE user data / custom data / cloud init
  tfe_user_data = templatefile(
    "${path.module}/templates/tfe.sh.tpl",
    {
      # Configuration data
      active_active               = var.tfe_configuration.enable_active_active.value == "1" ? true : false
      replicated                  = base64encode(jsonencode(var.replicated_configuration))
      settings                    = base64encode(jsonencode(var.tfe_configuration))
      tls_bootstrap_cert_pathname = var.replicated_configuration.TlsBootstrapCert
      tls_bootstrap_key_pathname  = var.replicated_configuration.TlsBootstrapKey

      # Secrets
      ca_certificate_secret     = var.ca_certificate_secret
      certificate_secret        = var.certificate_secret
      key_secret                = var.key_secret
      tfe_license_file_location = var.replicated_configuration.LicenseFileLocation
      tfe_license_secret        = var.tfe_license_secret

      # Proxy information
      proxy_ip   = var.proxy_ip
      proxy_port = var.proxy_port
      no_proxy   = var.tfe_configuration.extra_no_proxy.value
    }
  )
}

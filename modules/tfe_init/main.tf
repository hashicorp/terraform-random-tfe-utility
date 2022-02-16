locals {

  bootstrap_airgap = var.airgap_url != null ? var.bootstrap_airgap_installation != null ? var.bootstrap_airgap_installation ? true : !var.bootstrap_airgap_installation : false : false

  # Build TFE user data / custom data / cloud init
  tfe_user_data = templatefile(
    "${path.module}/templates/tfe.sh.tpl",
    {
      # Functions
      get_base64_secrets = data.template_file.get_base64_secrets.rendered

      # Configuration data
      cloud                         = var.cloud
      active_active                 = var.tfe_configuration.enable_active_active.value == "1" ? true : false
      replicated                    = base64encode(jsonencode(var.replicated_configuration))
      settings                      = base64encode(jsonencode(var.tfe_configuration))
      tls_bootstrap_cert_pathname   = var.replicated_configuration.TlsBootstrapCert
      tls_bootstrap_key_pathname    = var.replicated_configuration.TlsBootstrapKey
      airgap_url                    = var.airgap_url
      airgap_pathname               = var.airgap_url != null ? var.replicated_configuration.LicenseBootstrapAirgapPackagePath : null
      bootstrap_airgap_installation = var.airgap_url != null ? var.bootstrap_airgap_installation != null ? var.bootstrap_airgap_installation ? true : !var.bootstrap_airgap_installation : false : false

      # Secrets
      ca_certificate_secret     = var.ca_certificate_secret
      certificate_secret        = var.certificate_secret
      ca_certificate_data_b64   = !local.bootstrap_airgap ? var.ca_certificate_data_b64 != null ? var.ca_certificate_data_b64 : null : null
      certificate_data_b64      = !local.bootstrap_airgap ? var.certificate_data_b64 != null ? var.certificate_data_b64 : null : null
      key_data_b64              = !local.bootstrap_airgap ? var.key_data_b64 != null ? var.key_data_b64 : null : null
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

data "template_file" "get_base64_secrets" {
  template = file("${path.module}/templates/get_base64_secrets.func")

  vars = {
    cloud = var.cloud
  }
}
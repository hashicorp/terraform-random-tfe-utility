locals {

  # Build TFE user data / custom data / cloud init
  tfe_user_data = templatefile(
    "${path.module}/templates/tfe.sh.tpl",
    {
      # Functions
      get_base64_secrets = data.template_file.get_base64_secrets.rendered
      install_packages   = data.template_file.install_packages.rendered

      # Configuration data
      cloud                       = var.cloud
      distribution                = var.distribution
      active_active               = var.tfe_configuration.enable_active_active.value == "1" ? true : false
      replicated                  = base64encode(jsonencode(var.replicated_configuration))
      settings                    = base64encode(jsonencode(var.tfe_configuration))
      tls_bootstrap_cert_pathname = try(var.replicated_configuration.TlsBootstrapCert, null)
      tls_bootstrap_key_pathname  = try(var.replicated_configuration.TlsBootstrapKey, null)
      airgap_url                  = var.airgap_url
      airgap_pathname             = try(var.replicated_configuration.LicenseBootstrapAirgapPackagePath, null)

      # Secrets
      ca_certificate_secret_id  = var.ca_certificate_secret_id
      certificate_secret_id     = var.certificate_secret_id
      key_secret_id             = var.key_secret_id
      tfe_license_file_location = var.replicated_configuration.LicenseFileLocation
      tfe_license_secret_id     = var.tfe_license_secret_id

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

data "template_file" "install_packages" {
  template = file("${path.module}/templates/install_packages.func")

  vars = {
    cloud        = var.cloud
    distribution = var.distribution
  }
}
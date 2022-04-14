locals {

  # Build TFE user data / custom data / cloud init
  tfe_user_data = templatefile(
    "${path.module}/templates/tfe.sh.tpl",
    {
      # Functions
      get_base64_secrets        = data.template_file.get_base64_secrets.rendered
      install_packages          = data.template_file.install_packages.rendered
      install_monitoring_agents = data.template_file.install_monitoring_agents.rendered

      # Configuration data
      active_active               = var.tfe_configuration.enable_active_active.value == "1" ? true : false
      airgap_url                  = var.airgap_url
      airgap_pathname             = try(var.replicated_configuration.LicenseBootstrapAirgapPackagePath, null)
      cloud                       = var.cloud
      custom_image_tag            = try(var.tfe_configuration.custom_image_tag.value, null)
      disk_path                   = var.disk_path
      disk_device_name            = var.disk_device_name
      distribution                = var.distribution
      docker_config               = filebase64("${path.module}/files/daemon.json")
      enable_monitoring           = var.enable_monitoring != null ? var.enable_monitoring : false
      replicated                  = base64encode(jsonencode(var.replicated_configuration))
      settings                    = base64encode(jsonencode(var.tfe_configuration))
      tls_bootstrap_cert_pathname = try(var.replicated_configuration.TlsBootstrapCert, null)
      tls_bootstrap_key_pathname  = try(var.replicated_configuration.TlsBootstrapKey, null)

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

data "template_file" "install_monitoring_agents" {
  template = file("${path.module}/templates/install_monitoring_agents.func")

  vars = {
    cloud        = var.cloud
    distribution = var.distribution
  }
}
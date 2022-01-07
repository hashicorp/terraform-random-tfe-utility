resource "random_string" "password" {
  length  = 16
  special = false
}

locals {
  replicated_base_config = {
    BypassPreflightChecks        = true
    DaemonAuthenticationType     = "password"
    DaemonAuthenticationPassword = random_string.password.result
    ImportSettingsFrom           = "/etc/ptfe-settings.json"
    LicenseFileLocation          = var.tfe_license_file_location
    TlsBootstrapHostname         = var.fqdn
    TlsBootstrapCert             = var.tls_bootstrap_cert_pathname
    TlsBootstrapKey              = var.tls_bootstrap_key_pathname
    TlsBootstrapType             = var.certificate_secret == null ? "self-signed" : "server-path"
  }

  release_sequence = var.release_sequence != null ? local.release_sequence_map : {}

  release_sequence_map = {
    ReleaseSequence = var.release_sequence
  }
}

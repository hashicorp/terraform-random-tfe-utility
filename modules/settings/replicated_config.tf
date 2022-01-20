resource "random_string" "password" {
  length  = 16
  special = false
}

locals {
  replicated_base_config = {
    BypassPreflightChecks        = var.bypass_preflight_checks
    DaemonAuthenticationType     = "password"
    DaemonAuthenticationPassword = random_string.password.result
    ImportSettingsFrom           = "/etc/ptfe-settings.json"
    LicenseFileLocation          = var.tfe_license_file_location
    TlsBootstrapHostname         = var.hostname
    TlsBootstrapCert             = var.certificate_secret == null ? null : var.tls_bootstrap_cert_pathname
    TlsBootstrapKey              = var.certificate_secret == null ? null : var.tls_bootstrap_key_pathname
    TlsBootstrapType             = var.certificate_secret == null ? "self-signed" : "server-path"
    ReleaseSequence              = var.release_sequence
  }
}

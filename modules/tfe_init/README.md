# TFE Init Module

This module is used to create the script that will install Terraform Enterprise (TFE) on a virtual machine.

## Required variables

* `fqdn` - string value of the fully qualified domain name for the TFE environment
* `active_active` - boolean for whether or not it is an active-active installation
* `tfe_license_secret` - string value for the TFE license secret name
* `replicated_configuration` - output object from the [`settings` module](../settings) of the Replicated configuration
* `tfe_configuration` - output object from the [`settings` module](../settings) of the TFE configuration

## Example usage

This example illustrates how it may be used by a Terraform Enterprise module, consuming outputs from other submodules.

```hcl
module "tfe_init" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/tfe_init?ref=main"

  # Replicated Configuration data
  fqdn          = module.load_balancer.fqdn
  active_active = local.active_active

  tfe_configuration           = module.settings.tfe_configuration
  replicated_configuration    = module.settings.replicated_configuration
  tfe_license_file_location   = module.settings.replicated_configuration.LicenseFileLocation
  tls_bootstrap_cert_pathname = module.settings.replicated_configuration.TlsBootstrapCert
  tls_bootstrap_key_pathname  = module.settings.replicated_configuration.TlsBootstrapKey

  # Secrets
  ca_certificate_secret = var.ca_certificate_secret
  certificate_secret    = var.vm_certificate_secret
  key_secret            = var.vm_key_secret
  tfe_license_secret    = var.tfe_license_secret

  # Proxy information
  proxy_ip   = var.proxy_ip
  proxy_port = var.proxy_port
  no_proxy = [
    "127.0.0.1",
    "169.254.169.254",
    ".azure.com",
    ".windows.net",
    ".microsoft.com",
    module.load_balancer.fqdn,
    var.network_cidr
  ]
}
```

## Resources

This module does not create any Terraform resources, but rather uses the [`templatefile` function](https://www.terraform.io/language/functions/templatefile)
to render a template of the Terraform Enterprise installation script. The module will then output the
rendered script so that it can be used in a TFE installation.

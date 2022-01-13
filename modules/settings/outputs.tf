output "config" {
  value = {
    replicated_configuration = local.replicated_configuration
    tfe_configuration        = local.tfe_configuration
  }

  description = "The settings that will be used to configure Replicated and Terraform Enterprise."
}

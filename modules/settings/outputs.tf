output "config" {
  value = {
    replicated_configuration = jsonencode(local.replicated_configuration)
    tfe_configuration        = jsonencode(local.tfe_configuration)
  }

  description = "The settings that will be used to configure Replicated and Terraform Enterprise."
}

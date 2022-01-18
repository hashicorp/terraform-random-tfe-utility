// output "config" {
//   value = {
//     replicated_configuration = base64encode(jsonencode(local.replicated_configuration))
//     tfe_configuration        = base64encode(jsonencode(local.tfe_configuration))
//   }

//   description = "The settings that will be used to configure Replicated and Terraform Enterprise."
// }


output "replicated_configuration" {
  value       = local.replicated_configuration
  description = "The settings that will be used to configure Replicated."
}

output "tfe_configuration" {
  value       = local.tfe_configuration
  description = "The settings that will be used to configure Terraform Enterprise."
}
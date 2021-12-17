output "tfe_userdata_base64_encoded" {
  value       = base64encode(local.tfe_user_data)
  description = "The Base64 encoded User Data script built from modules/user_data/templates/tfe.sh.tpl"
}

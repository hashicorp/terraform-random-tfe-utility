output "url" {
  value       = hcp_vault_cluster.test.vault_public_endpoint_url
  description = "The public endpoint of the HCP Vault Cluster."
}

output "app_role_id" {
  value       = vault_approle_auth_backend_role.approle.role_id
  description = "The role ID of the Vault's app role."
}

output "app_role_secret_id" {
  value       = vault_approle_auth_backend_role_secret_id.approle.secret_id
  description = "The secret ID of the Vault's app role."
}

output "token" {
  value       = hcp_vault_cluster_admin_token.test.token
  sensitive   = true
  description = "The Vault token"
}

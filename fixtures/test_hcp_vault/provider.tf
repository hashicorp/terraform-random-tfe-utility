# Credentials will be set via the environment variables HCP_CLIENT_ID and HCP_CLIENT_SECRET
provider "vault" {
  address = hcp_vault_cluster.test.vault_public_endpoint_url
  token   = hcp_vault_cluster_admin_token.test.token
}
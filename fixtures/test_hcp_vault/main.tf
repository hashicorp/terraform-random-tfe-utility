# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Vault AppRole
# -------------
resource "hcp_vault_cluster" "test" {
  cluster_id      = var.hcp_vault_cluster_id
  hvn_id          = var.hcp_vault_cluster_hvn_id
  public_endpoint = var.hcp_vault_cluster_public_endpoint
  tier            = var.hcp_vault_cluster_tier
}

resource "hcp_vault_cluster_admin_token" "test" {
  cluster_id = hcp_vault_cluster.test.cluster_id
}

# Vault Policy
# -------------
resource "vault_policy" "ptfe" {
  name = var.vault_policy_name

  policy = <<EOT
# To renew leases.
path "sys/leases/renew" {
  capabilities = ["create", "update"]
}
path "sys/renew" {
  capabilities = ["create", "update"]
}

# To renew tokens.
path "auth/token/renew" {
  capabilities = ["create", "update"]
}
path "auth/token/renew-self" {
  capabilities = ["create", "update"]
}

# To perform a login.
path "auth/approle/login" {
  capabilities = ["create", "update"]
}

# To upsert transit keys used for key generation.
path "transit/keys/atlas_*" {
 capabilities = ["read", "create", "update"]
}
path "transit/keys/archivist_*" {
  capabilities = ["read", "create", "update"]
}

# Encryption and decryption of data.
path "transit/encrypt/atlas_*" {
  capabilities = ["create", "update"]
}
path "transit/decrypt/atlas_*" {
  capabilities = ["create", "update"]
}
path "transit/encrypt/archivist_*" {
  capabilities = ["create", "update"]
}
path "transit/decrypt/archivist_*" {
  capabilities = ["create", "update"]
}

# For performing key derivation.
path "transit/datakey/plaintext/archivist_*" {
  capabilities = ["create", "update"]
}

# For backup/restore operations.
path "transit/keys/atlas_*/config" {
  capabilities = ["read", "create", "update"]
}
path "transit/backup/atlas_*" {
  capabilities = ["read"]
}
path "transit/restore/atlas_*" {
  capabilities = ["read", "create", "update"]
}
path "transit/keys/archivist_*/config" {
  capabilities = ["read", "create", "update"]
}
path "transit/backup/archivist_*" {
  capabilities = ["read"]
}
path "transit/restore/archivist_*" {
  capabilities = ["read", "create", "update"]
}

# For health checks to read the mount table.
path "sys/mounts" {
  capabilities = ["read"]
}
EOT
}

# Vault AppRole
# -------------
resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "approle" {
  backend        = vault_auth_backend.approle.path
  role_name      = var.vault_role_name
  token_policies = [vault_policy.ptfe.name]
}

resource "vault_approle_auth_backend_role_secret_id" "approle" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.approle.role_name
}

resource "vault_mount" "transit" {
  path = "transit"
  type = "transit"
}

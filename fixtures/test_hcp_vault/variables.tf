# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "hcp_vault_cluster_id" {
  type        = string
  description = "The ID of the HCP Vault cluster."
}

variable "hcp_vault_cluster_hvn_id" {
  type        = string
  description = "The ID of the HVN to which this HCP Vault cluster is associated."
}

variable "hcp_vault_cluster_public_endpoint" {
  type        = bool
  description = "Denotes that the cluster has a public endpoint."
}

variable "hcp_vault_cluster_tier" {
  type        = string
  description = "Tier of the HCP Vault cluster. Must be standard_medium or standard_large."

  validation {
    condition = (
      var.hcp_vault_cluster_tier == "standard_medium" ||
      var.hcp_vault_cluster_tier == "standard_large"
    )

    error_message = "The hcp_vault_cluster_tier must be 'standard_medium' or 'standard_large'."
  }
}

variable "vault_role_name" {
  type        = string
  description = "The name of the vault role."
}

variable "vault_policy_name" {
  type        = string
  description = "The name of the vault policy."
}
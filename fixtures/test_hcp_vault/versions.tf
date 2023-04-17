# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">= 0.14"
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.33.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.1"
    }
  }
}

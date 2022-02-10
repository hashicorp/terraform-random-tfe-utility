terraform {
  required_version = ">= 0.14"
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.18.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.1"
    }
  }
}
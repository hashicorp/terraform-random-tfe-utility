# Test Bastion Init

This fixture provides initialization scripts for bastion servers which
are used in tests. This module only generates the contents of a
cloud-init scripts. The script will:
- add the TFE private key to the bastion virtual machine
- add `ssh-config` files for the IP addresses that are passed in

## Example Usage

```tf

# Create the init script from the template
module "test_bastion_init" {
  source = "github.com/hashicorp/terraform-random-tfe-utility//fixtures/test_bastion_init"

  tfe_instance_ip_addresses   = ["10.0.32.4", "10.0.32.5"]
  tfe_instance_user_name      = "tfeuser"
  tfe_private_key_path        = "~/.ssh/private-key.pem"
  tfe_private_key_data_base64 = base64encode(module.azure_public_active_active.instance_private_key)
  tfe_ssh_config_path         = "~/.ssh/ssh_config_"
}

# Use the init script in the custom data of the bastion virtual machine
module "azurerm_bastion_vm" {
  source               = "git::https://git@github.com/hashicorp/terraform-azurerm-terraform-enterprise.git//fixtures/bastion_vm"
  friendly_name_prefix = random_string.azure_public_active_active.id

  location             = "Central US"
  resource_group_name  = "my_rg"
  virtual_network_name = "my-vnet"
  network_allow_range  = "*"
  bastion_subnet_cidr  = "10.0.16.0/20"
  ssh_public_key       = tls_private_key.bastion_ssh.public_key_openssh
  bastion_user         = "bastionuser"
  bastion_custom_data  = module.test_bastion_init.custom_data_setup_ssh

  tags = local.common_tags
}

resource "tls_private_key" "bastion_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

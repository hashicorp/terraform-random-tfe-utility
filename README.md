# terraform-random-tfe-utility

**IMPORTANT**: You are viewing a **beta version** of the utility
modules used to support installations of Terraform Enterprise. This
is not currently meant for production use. Please contact your Customer
Success Manager for details before using.

This is an open-source repository that houses modules that centralize
logic for creating utilities that are common to all Terraform Enterprise
modules.

## About This Repository

This repository contains both modules that are necessary for TFE installations
as well as fixture modules that set up utilities that are common to TFE
installations but not required. Please see the READMEs of each module for
further details.

### Terraform version >= 0.13

* This module requires Terraform version `0.13` or greater to be installed on
the running machine.

### Testing

Testing of the Utility modules is done through the GitHub Actions of this
repository which leverages Terraform Cloud workspaces to allow maintainers
to run and audit contributions to this repository. Maintainers will choose
which test scenarios are necessary to run for the changes that are being
proposed.

Test modules from the following repositories are used:

* [AWS](https://github.com/hashicorp/terraform-aws-terraform-enterprise/blob/main/tests/README.md)
* [AzureRM](https://github.com/hashicorp/terraform-azurerm-terraform-enterprise/blob/main/tests/README.md)
* [Google](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/main/tests/README.md)

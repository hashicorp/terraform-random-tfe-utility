# EXAMPLE: [Standalone / Active-Active], [operational type], [environment (optional)] Installation of Terraform Enterprise

## About This Example

> *This section describes the high level traits of the TFE installation*

> PLEASE UPDATE APPLICABLE TRAITS IN *[(XXXXXXX)]*

This example for Terraform Enterprise creates a TFE installation with the following traits:

-  [(Standalone / Active/Active)] architecture
-  [(External Services / Mounted Disk)] production type
-  [(Airgapped)] 
-  [(n1-standard-4 / Standard_D4_v3 / m5.xlarge)] virtual machine type
-  [(Ubuntu 20.04,  RHEL 7.9)]
-  A [(publicly / privately)] accessible [(HTTP / TCP)] load balancer with TLS [(termination / pass-through)] 
-  An ubuntu based [(mitm / squid)]proxy server with TLS termination 

## Prerequisites

 > *This section describes the prerequisites assumed by the installation modules.*
 > *Prerequisites are external resources that the module consumes like TFE license,certificates, vm-image, airgap package etc*

> PLEASE INCLUDE ONLY APPLICABLE PREREQUISITES 

This example assumes that the following resources exist:

- TFE license is on a file path defined by `var.license_file` 
- Airgap prerequisites :
  - The vm image (only for completely air-gapped environment) is prepared according to the [documentation](https://www.terraform.io/enterprise/install/interactive/installer#prepare-the-instance)
    - Certificate and key data is present on the vm image at the following paths (when applicable):
      - The value of the secret represented by the root module's key_secret_id variable is present at the  path defined by var.tls_bootstrap_cert_pathname (0600 access permissions).
      - The value of the secret represented by the root module's certificate_secret_id variable is present at the path defined by var.tls_bootstrap_key_pathname (0600 access permissions).
      - The value of the secret represented by the root module's ca_certificate_secret_id variable is present at the path:
        - RHEL   - /usr/share/pki/ca-trust-source/anchors/tfe-ca-certificate.crt
        - Ubuntu - /usr/local/share/ca-certificates/extra/tfe-ca-certificate.crt
  - The URL of an airgap package
  - The airgap package is on a filepath defined by var.tfe_license_bootstrap_airgap_package_path
  - The extracted Replicated package from https://install.terraform.io/airgap/latest.tar.gz is at `/tmp/replicated/replicated.tar.gz`
- A DNS zone
- Valid managed SSL certificate to use with load balancer:
  - GCP   - Create/Import a managed SSL Certificate in Network Services -> Load Balancing to serve as the certificate for the DNS A Record.
  - AWS   - Create/Import a managed SSL Certificate using AWS ACM to serve as the certificate for the DNS A Record.
  - Azure - An Azure Key Vault in which the following are stored:
    - TFE CA certificate (certificate)
    - Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual Machine Scale Set
    - Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine Scale Set.
- Valid CA certificate and private key for MITM proxy *(applicable only if MITM proxy is used)*
  - GCP - GCP Secret ID which contains the Base64 encoded version of a PEM encoded certificate and private key for mitm proxy server.
  - AWS - AWS Secret Manager Secret name which contains the Base64 encoded version of a PEM encoded certificate and private key for mitm proxy server.
  - Azure - An Azure Key Vault secret which contains the Base64 encoded version of a PEM encoded certificate and private key for mitm proxy server.
  
## How to Use This Module

> *This section provides step-by-step instructions on how to run the module for each cloud provider. This includes steps on how to set credentials, provider block, creating any local files such as terraform.auto.tfvars and commands that are triggered to init, plan and apply.*

> PLEASE UPDATE APPLICABLE VALUES IN *[(XXXXXXX)]* 

### Deployment

 1. Read the entire [README.md](../../README.md) of the root module.
 2. Ensure account meets module prerequisites from above.
 3. Clone repository.
 4. Change directory into desired example folder.
 5. Create a local `terraform.auto.tfvars` file and instantiate the required inputs as required in the respective `./examples/[(example-name)]/variables.tf` including the path to the license under the `license_file` variable value.
 6. Authenticate against the [(AWS/AZURERM/GOOGLE)] provider. See [instructions](replace with appropriate URL below).
    - <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli>
    - <https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration>
    - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication>
 7. Initialize terraform and apply the module configurations using the commands below :

    NOTE: `terraform plan` will print out the execution plan which describes the actions Terraform will take in order to build your infrastructure to match the module configuration. If anything in the plan seems incorrect or dangerous, it is safe to abort here and not proceed to `terraform apply`

    ```
    terraform init
    terraform plan
    terraform apply
    ```

## Post-deployment Tasks

> *This section describes activities after deployment is triggered. If a proxy is deployed, provide instructions to set up local connection to the proxy as well.*

The build should take approximately 10-15 minutes to deploy. Once the module has completed, give the platform another 10 minutes or so prior to attempting to interact with it in order for all containers to start up.

Unless amended, this example will not create an initial admin user using the IACT, but it does output the URL for your convenience. Follow the advice in this document to create the initial admin user, and log into the system using this user in order to configure it for use.

### Connecting to [proxy/bastion] server

> *Applicable only when connecting via proxy/bastion host.*
> *In short, to set up a proxy server in Google Chrome, you're just doing the first few steps in the browser, and then completing the process in your machine's operating system*

1. To create a tunnel for Chrome:
   By default, Chrome uses your macOS or Windows proxy. To change your proxy settings from within Chrome, take the following steps: 
   - Open the Chrome toolbar and select "Settings".
   - Scroll down to the bottom of the display. Click on "Show advanced settings".
   - Scroll down to “System” and choose "Open your computer’s proxy settings".
   - Set Chrome proxy server settings.
   
2. Next, follow the instructions for your operating system to set up your proxy server settings:
   - [macOS](https://support.apple.com/en-ca/guide/mac-help/mchlp2591/mac)
   - [Windows](https://www.dummies.com/article/technology/computers/operating-systems/windows/windows-10/how-to-set-up-a-proxy-in-windows-10-140262/#tab2)
   
3. SSH to proxy/bastion via: `$ ssh -N -p 22 -D localhost:5000 <[bastionuser/proxyuser]>@<[bastionhost/proxyserver]> -i ../path/to/id_rsa`
4. The TFE URL is now aacessible via [proxy/bastion].

### Connecting to the TFE Console

> *Applicable only for standalone environment*

The TFE Console is only available in a standalone environment

1. Navigate to the URL supplied via `tfe_console_url` Terraform output
2. Copy the `tfe_console_password` Terraform output
3. Enter the console password
4. Click `Unlock`

### Connecting to the TFE Application

1. Navigate to the URL supplied via the `login_url` Terraform output. (It may take several minutes for this to be available after initial deployment - you may monitor the progress of cloud init if desired on one of the instances)
2. Enter a `username`, `email`, and `password` for the initial user.
3. Click `Create an account`.
4. After the initial user is created you may access the TFE Application normally using the URL supplied via `tfe_application_url` Terraform output.

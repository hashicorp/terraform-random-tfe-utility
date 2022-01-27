# ------------------------------------------------------
# TFE
# ------------------------------------------------------
variable "capacity_concurrency" {
  default     = null
  type        = number
  description = "Number of concurrent plans and applies; defaults to 10."
}

variable "capacity_cpus" {
  default     = null
  type        = number
  description = <<-EOD
  The maximum number of CPU cores that a Terraform plan or apply can use on the system;
  defaults to 0 (unlimited).
  EOD
}

variable "capacity_memory" {
  default     = null
  type        = number
  description = <<-EOD
  The maximum amount of memory (in megabytes) that a Terraform plan or apply can use on the system;
  defaults to 512.
  EOD
}

variable "vault_path" {
  default = null
  type = string
  description = <<-EOD
  (Optional) Path on the host system to store the vault files. If extern_vault_enable is set, this
  has no effect.
  EOD
}

variable "vault_store_snapshot" {
  default = null
  type = bool
  description = "(Optional) Indicate if the vault files should be stored in snapshots. Defaults to true."
}

variable "release_sequence" {
  default     = null
  type        = number
  description = <<-EOD
  Terraform Enterprise version release sequence. Pins the application to a release available in the
  license's channel, but is overridden by pins made in the vendor console. This setting is optional
  and has to be omitted when LicenseBootstrapAirgapPackagePath is set.
  EOD
}

variable "iact_subnet_list" {
  default     = null
  type        = list(string)
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be
  expressed in CIDR notation, for example "["10.0.0.0/24"]". If not set, no subnets can retrieve
  the IACT.
  EOD
}

variable "installation_type" {
  type        = string
  description = "(Required) Installation type for Terraform Enterprise"

  validation {
    condition = (
      var.installation_type == "poc" ||
      var.installation_type == "production"
    )

    error_message = "The installation type must be 'production' (recommended) or 'poc' (only used for demo-mode)."
  }
}

variable "production_type" {
  default     = null
  type        = string
  description = <<-EOD
  If you have chosen 'production' for the installation_type, production_type is required:
  external or disk
  EOD

  validation {
    condition = (
      var.production_type == "external" ||
      var.production_type == "disk" ||
      var.production_type == null
    )

    error_message = "The production type must be 'external' or 'disk'."
  }
}

# ------------------------------------------------------
# Proxy
# ------------------------------------------------------
variable "trusted_proxies" {
  default     = null
  type        = list(string)
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP
  addresses of requests like those made to the IACT endpoint.
  EOD
}

variable "extra_no_proxy" {
  default     = null
  type        = list(string)
  description = <<-EOD
  When configured to use a proxy, a list of hosts to exclude from proxying. Please note that
  this list does not support whitespace characters.
  EOD
}

# ------------------------------------------------------
# TLS
# ------------------------------------------------------
variable "tls_vers" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional) Set to tls_1_2 to enable only TLS 1.2, or to tls_1_3 to enable only TLS 1.3. When
  unset, TFE defaults to both TLS 1.2 and 1.3 (tls_1_2_tls_1_3).
  EOD

  validation {
    condition = (
      var.tls_vers == "tls_1_2_tls_1_3" ||
      var.tls_vers == "tls_1_2" ||
      var.tls_vers == "tls_1_3" ||
      var.tls_vers == null
    )

    error_message = "The tls_vers should be set to 'tls_1_2' to enable only TLS 1.2, to 'tls_1_3' to enable only TLS 1.3. When unset, TFE defaults to both TLS 1.2 and 1.3 'tls_1_2_tls_1_3'."
  }
}

variable "tls_ciphers" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional) Set to an OpenSSL cipher list format string to enable a custom TLS ciphersuite.
  When unset, TFE uses a default ciphersuite.
  EOD
}

variable "force_tls" {
  default     = null
  type        = bool
  description = <<-EOD
  When set, TFE will require all application traffic to use HTTPS by sending a 'Strict-Transport-Security'
  header value in responses, and marking cookies as secure. A valid, trusted TLS certificate must be
  installed when this option is set, as browsers will refuse to serve webpages that have an HSTS
  header set that also serve self-signed or untrusted certificates.
  EOD
}

# ------------------------------------------------------
# Replicated
# ------------------------------------------------------
variable "hostname" {
  default     = null
  type        = string
  description = "(Required) The hostname you will use to access your installation."
}

variable "enable_active_active" {
  default     = false
  type        = bool
  description = <<-EOD
  True if TFE running in active-active configuration, which requires an external Redis server;
  defaults to false.
  EOD
}

variable "tfe_license_file_location" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the TFE license."
}

variable "tls_bootstrap_cert_pathname" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the certificate."
}

variable "tls_bootstrap_key_pathname" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the key."
}

variable "bypass_preflight_checks" {
  default     = null
  type        = bool
  description = "Allow the TFE application to start without preflight checks; defaults to false."
}

# ------------------------------------------------------
# PostgreSQL Database
# ------------------------------------------------------
# If you have chosen external for production_type, the following settings apply:
variable "pg_user" {
  default     = null
  type        = string
  description = "(Required when production_type is 'external') PostgreSQL user to connect as."
}

variable "pg_password" {
  default     = null
  type        = string
  description = "(Required when production_type is 'external') The password for the PostgreSQL user."
}

variable "pg_netloc" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when production_type is 'external') The hostname and port of the target PostgreSQL
  server, in the format hostname:port.
  EOD
}

variable "pg_dbname" {
  default     = null
  type        = string
  description = "(Required when production_type is 'external') The database name"
}

variable "pg_extra_params" {
  default     = null
  type        = string
  description = <<-EOF
  (Optional) Parameter keywords of the form param1=value1&param2=value2 to support additional
  options that may be necessary for your specific PostgreSQL server. Allowed values are documented
  on the PostgreSQL site. An additional restriction on the sslmode parameter is that only the
  require, verify-full, verify-ca, and disable values are allowed.
  EOF
}

# ------------------------------------------------------
# Redis
# ------------------------------------------------------
variable "redis_host" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when enable_active_active is true) Hostname of an external Redis instance which is
  resolvable from the TFE instance.
  EOD
}

variable "redis_pass" {
  default     = null
  type        = string
  description = <<-EOD
  The Primary Access Key for the Redis Instance. Must be set to the password of an external Redis
  instance if the instance requires password authentication.
  EOD
}

variable "redis_use_password_auth" {
  default     = null
  type        = bool
  description = "Redis service requires a password."
}

variable "redis_use_tls" {
  default     = null
  type        = bool
  description = <<-EOD
  Redis service requires TLS. If true, the external Redis instance will use port 6380,
  otherwise 6379.
  EOD
}

# ------------------------------------------------------
# Mounted Disk
# ------------------------------------------------------
variable "disk_path" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when production_type is 'disk') Absolute path to a directory on the instance to store
  Terraform Enteprise data. Valid for mounted disk installations.
  EOD
}

# ------------------------------------------------------
# AWS
# ------------------------------------------------------
variable "aws_instance_profile" {
  default     = null
  type        = bool
  description = <<-EOD
  (Optional when object storage is in AWS) When true, use credentials from the AWS instance profile.

  EOD
}

variable "aws_access_key_id" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in AWS unless aws_instance_profile is set) AWS access key ID for
  S3 bucket access. To use AWSinstance profiles for this information, set it to ''.
  EOD
}

variable "aws_secret_access_key" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in AWS unless aws_instance_profile is set) AWS secret access key
  for S3 bucket access. To use AWS instance profiles for this information, set it to ''.
  EOD
}

variable "s3_endpoint" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when object storage is in AWS) Endpoint URL (hostname only or fully qualified URI).
  Usually only needed if using a VPC endpoint or an S3-compatible storage provider.
  EOD
}

variable "s3_bucket" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in AWS) The S3 bucket where resources will be stored.
  
  EOD
}

variable "s3_region" {
  default     = null
  type        = string
  description = "(Required when object storage is in AWS) The region where the S3 bucket exists."
}

variable "s3_sse" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when object storage is in AWS) Enables server-side encryption of objects in S3; if
  provided, must be set to aws:kms.
  EOD
}

variable "s3_sse_kms_key_id" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when object storage is in AWS) An optional KMS key for use when S3 server-side
  encryption is enabled.
  EOD
}

# ------------------------------------------------------
# Azure
# ------------------------------------------------------
variable "azure_account_name" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in Azure) The account name for the Azure account to access
  the container.
  EOD
}

variable "azure_account_key" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in Azure) The account key to access the account specified in
  azure_account_name.
  EOD
}

variable "azure_container" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in Azure) The identifer for the Azure blob storage container.

  EOD
}


variable "azure_endpoint" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when object storage is in Azure) The URL for the Azure cluster to use. By default this
  is the global cluster.
  EOD
}

# ------------------------------------------------------
# Google
# ------------------------------------------------------
variable "gcs_bucket" {
  default     = null
  type        = string
  description = "(Required when object storage is in GCP) The GCP storage bucket name."
}

variable "gcs_credentials" {
  default     = null
  type        = string
  description = <<-EOD
  (Required when object storage is in GCP) JSON blob containing the GCP credentials document.
  Note: This is a string, so ensure values are properly escaped."
  EOD
}

variable "gcs_project" {
  default     = null
  type        = string
  description = "(Required when object storage is in GCP) The GCP project where the bucket resides."
}

# ------------------------------------------------------
# External Vault
# ------------------------------------------------------
variable "extern_vault_enable" {
  default = null
  type    = bool
  description = "(Optional) An external Vault cluster is being used."
}

variable "extern_vault_addr" {
  default = null
  type = string
  description = "(Required when extern_vault_enable is true) URL of external Vault cluster."
}

variable "extern_vault_role_id" {
  default = null
  type = string
  description = <<-EOD
  (Required when extern_vault_enable is true) AppRole RoleId to use to authenticate with the Vault
  cluster.
  EOD
}

variable "extern_vault_secret_id" {
  default = null
  type = string
  description = <<-EOD
  (Required when extern_vault_enable is true) AppRole SecretId to use to authenticate with the Vault
  cluster.
  EOD
}

variable "extern_vault_path" {
  default = null
  type = string
  description = <<-EOD
  (Optional when extern_vault_enable is true) Path on the Vault server for the AppRole auth.
  Defaults to auth/approle.
  EOD
}

variable "extern_vault_token_renew" {
  default = null
  type = number
  description = <<-EOD
  (Optional when extern_vault_enable is true) How often (in seconds) to renew the Vault token.
  Defaults to 3600.
  EOD
}

variable "extern_vault_propagate" {
  default = null
  type = bool
  description = <<-EOD
  (Optional when extern_vault_enable is true) Propagate Vault credentials to Terraform workers.
  Defaults to false.
  EOD
}

variable "extern_vault_namespace" {
  default = null
  type = string
  description = <<-EOD
  (Optional when extern_vault_enable is true) The Vault namespace under which to operate.
  Defaults to ''.
  EOD
}
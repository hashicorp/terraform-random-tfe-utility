variable "tfe_image" {
  description = "The registry path, image name, and image version (e.g. \"quay.io/hashicorp/terraform-enterprise:1234567\")"
}

variable "tls_ca_bundle_file" {
  default = null
  description = "Path to a file containing TLS CA certificates to be added to the OS CA certificates bundle. Leave blank to not add CA certificates to the OS CA certificates bundle. Defaults to \"\"."
}

variable "tls_ciphers" {
  default = null
  description = "TLS ciphers to use for TLS. Must be valid OpenSSL format. Leave blank to use the default ciphers. Defaults to \"\"."
}

variable "tls_version" {
  default = null
  description = "TLS version to use. Must be one of tls_1_2, tls_1_3, or blank. Leave blank to use both TLS v1.2 and TLS v1.3. Defaults to \"\"."
}

variable "run_pipeline_image" {
  default = null
  description = "Container image used to execute Terraform runs. Leave blank to use the default image that comes with Terraform Enterprise. Defaults to \"\"."
}

variable "capacity_concurrency" {
  default = 10
  description = "Maximum number of Terraform runs that can execute concurrently on each Terraform Enterprise node. Defaults to 10."
}

variable "capacity_cpu" {
  default = 0
  description = "Maximum number of CPU cores a Terraform run is allowed to use. Set to 0 for no limit. Defaults to 0."
}

variable "capacity_memory" {
  default = 2048
  description = "Maximum amount of memory (MiB) a Terraform run is allowed to use. Defaults to 2048."
}

variable "iact_subnets" {
  default = null
  description = "Comma-separated list of subnets in CIDR notation that are allowed to retrieve the initial admin creation token via the API (e.g. 10.0.0.0/8,192.168.0.0/24). Leave blank to disable retrieving the initial admin creation token via the API from outside the host. Defaults to \"\"."
}

variable "iact_time_limit" {
  default = 60
  description = "Number of minutes that the initial admin creation token can be retrieved via the API after the application starts. Defaults to 60."
}

# Database
variable "database_user" {
  default = null
  description = "PostgreSQL user. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_password" {
  default = null
  description = "PostgreSQL password. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_host" {
  default = null
  description = "The PostgreSQL server to connect to in the format HOST[:PORT] (e.g. db.example.com or db.example.com:5432). If only HOST is provided then the :PORT defaults to :5432.Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_name" {
  default = null
  description = "Name of the PostgreSQL database to store application data in. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_parameters" {
  default = null
  description = "PostgreSQL server parameters for the connection URI. Used to configure the PostgreSQL connection (e.g. sslmode=require)."
}

# Storage
variable "storage_type" {
  description = "Type of object storage to use. Must be one of s3, azure, or google. Required when TFE_OPERATIONAL_MODE is external or active-active."
  validation {
    condition     = contains(["s3", "google", "azure"], var.storage_type)
    error_message = "The storage_type value must be one of: \"s3\"; \"google\"; \"azure\"."
  }
}

variable "s3_access_key_id" {
  default = null
  description = "S3 access key ID. Required when TFE_OBJECT_STORAGE_TYPE is s3 and TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE is false."
}

variable "s3_secret_access_key" {
  default = null
  description = "S3 secret access key. Required when TFE_OBJECT_STORAGE_TYPE is s3 and TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE is false."

}

variable "s3_region" {
  default = null
  description = "S3 region. Required when TFE_OBJECT_STORAGE_TYPE is s3."
}

variable "s3_bucket" {
  default = null
  description = "S3 bucket name. Required when TFE_OBJECT_STORAGE_TYPE is s3."
}

variable "s3_endpoint" {
  default = null
  description = "S3 endpoint. Useful when using a private S3 endpoint. Leave blank to use the default AWS S3 endpoint. Defaults to \"\"."
}

variable "s3_server_side_encryption" {
  default = null
  description = "Server-side encryption algorithm to use. Set to aws:kms to use AWS KMS. Leave blank to disable server-side encryption. Defaults to \"\"."
}

variable "s3_server_side_encryption_kms_key_id" {
  default = null
  description = "KMS key ID to use for server-side encryption. Leave blank to use AWS-managed keys. Defaults to \"\"."
}

variable "s3_use_instance_profile" {
  default = null
  description = "Whether to use the instance profile for authentication. Defaults to false."
}

variable "azure_account_key" {
  default = null
  description = "Azure Blob Storage access key. Required when TFE_OBJECT_STORAGE_TYPE is azure and TFE_OBJECT_STORAGE_AZURE_USE_MSI is false."
}

variable "azure_account_name" {
  default = null
  description = "Azure Blob Storage account name. Required when TFE_OBJECT_STORAGE_TYPE is azure."
}

variable "azure_container" {
   default = null
  description = "Azure Blob Storage container name. Required when TFE_OBJECT_STORAGE_TYPE is azure."
}

variable "azure_endpoint" {
  default = null
  description = "Azure Storage endpoint. Useful if using a private endpoint for Azure Stoage. Leave blank to use the default Azure Storage endpoint. Defaults to \"\". "
}

variable "google_bucket" {
  default = null
  description = "Google Cloud Storage bucket name. Required when TFE_OBJECT_STORAGE_TYPE is google."
}

variable "google_credentials" {
  default = null
  description = "Google Cloud Storage JSON credentials. Must be given as an escaped string of JSON or Base64 encoded JSON. Leave blank to use the attached service account. Defaults to \"\"."
}

variable "google_project" {
  default = null
  description = "Google Cloud Storage project name. Required when TFE_OBJECT_STORAGE_TYPE is google."
}

# Vault
variable "vault_address" {
  default = null
  description = "Address of the external Vault server (e.g. https://vault.example.com:8200). Defaults to \"\". Required when TFE_VAULT_USE_EXTERNAL is true."
}

variable "vault_namespace" {
  default = null
  description = "Vault namespace. External Vault only. Leave blank to use the default namespace. Defaults to \"\"."
}

variable "vault_path" {
  default = null
  description = "Vault path when AppRole is mounted. External Vault only. Defaults to auth/approle."
}

variable "vault_role_id" {
  default = null
  description = "Vault role ID. External Vault only. Required when TFE_VAULT_USE_EXTERNAL is true."
}

variable "vault_secret_id" {
  default = null
  description = "Vault secret ID. External Vault only. Required when TFE_VAULT_USE_EXTERNAL is true."
}

# Redis
variable "redis_host" {
  default = null
  description = "The Redis server to connect to in the format HOST[:PORT] (e.g. redis.example.com or redis.example.com:). If only HOST is provided then the :PORT defaults to :6379. Required when TFE_OPERATIONAL_MODE is active-active."
}

variable "redis_user" {
  default = null
  description = "Redis server user. Leave blank to not use a user when authenticating. Defaults to \"\"."
}

variable "redis_password" {
  default = true
  description = "Redis server password. Required when TFE_REDIS_USE_AUTH is true."
}

variable "redis_use_tls" {
  default = false
  description = "Whether or not to use TLS to access Redis. Defaults to false."
}

variable "redis_use_auth" {
  default = null
  description = "Whether or not to use authentication to access Redis. Defaults to false."
}

variable "tfe_license" {
  description = "The HashiCorp license. Defaults to \"\". Required when TFE_LICENSE_PATH is unset."
}

variable "hostname" {
  description = "Hostname where Terraform Enterprise is accessed (e.g. terraform.example.com)."
}

variable "operational_mode" {
  description = "Terraform Enterprise operational mode. Must be one of \"disk\", \"external\", or \"active-active\"."
}

variable "cert_file" {
  description = "Path to a file containing the TLS certificate Terraform Enterprise will use when serving TLS connections to clients."
}

variable "key_file" {
  description = "Path to a file containing the TLS private key Terraform Enterprise will use when serving TLS connections to clients."
}

variable "license_reporting_opt_out" {
  default     = "false"
  description = "Whether to opt out of reporting licensing information to HashiCorp. Defaults to false."
}

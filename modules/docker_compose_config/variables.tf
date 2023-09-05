variable "tfe_image" {
  default     = null
  type        = string
  description = "The registry path, image name, and image version (e.g. \"quay.io/hashicorp/terraform-enterprise:1234567\")"
}

variable "tls_ca_bundle_file" {
  default     = null
  type        = string
  description = "Path to a file containing TLS CA certificates to be added to the OS CA certificates bundle. Leave blank to not add CA certificates to the OS CA certificates bundle. Defaults to \"\" if no value is given."
}

variable "tls_ciphers" {
  default     = null
  type        = string
  description = "TLS ciphers to use for TLS. Must be valid OpenSSL format. Leave blank to use the default ciphers. Defaults to \"\" if no value is given."
}

variable "tls_version" {
  default = null
  type        = string
  description = "TLS version to use. Leave blank to use both TLS v1.2 and TLS v1.3. Defaults to `\"\"` if no value is given."
  validation {
    condition     = contains(["tls_1_2", "tls_1_3", null], var.tls_version)
    error_message = "The tls_version value must be 'tls_1_2', 'tls_1_3', or null."
  }
}

variable "run_pipeline_image" {
  default     = null
  type        = string
  description = "Container image used to execute Terraform runs. Leave blank to use the default image that comes with Terraform Enterprise. Defaults to \"\" if no value is given."
}

variable "capacity_concurrency" {
  default     = 10
  type        = number
  description = "Maximum number of Terraform runs that can execute concurrently on each Terraform Enterprise node. Defaults to 10 if no value is given."
}

variable "capacity_cpu" {
  default     = 0
  type        = number
  description = "Maximum number of CPU cores a Terraform run is allowed to use. Set to 0 for no limit. Defaults to 0."
}

variable "capacity_memory" {
  default     = 2048
  type        = number
  description = "Maximum amount of memory (MiB) a Terraform run is allowed to use. Defaults to 2048 if no value is given."
}

variable "iact_subnets" {
  default     = null
  type        = list(string)
  description = "Comma-separated list of subnets in CIDR notation that are allowed to retrieve the initial admin creation token via the API (e.g. 10.0.0.0/8,192.168.0.0/24). Leave blank to disable retrieving the initial admin creation token via the API from outside the host. Defaults to \"\" if no value is given."
}

variable "iact_time_limit" {
  default     = null
  type        = number
  description = "Number of minutes that the initial admin creation token can be retrieved via the API after the application starts. Defaults to 60 if no value is given."
}

# Database
variable "database_user" {
  default     = null
  type        = string
  description = "PostgreSQL user. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_password" {
  default     = null
  type        = string
  description = "PostgreSQL password. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_host" {
  default     = null
  type        = string
  description = "The PostgreSQL server to connect to in the format HOST[:PORT] (e.g. db.example.com or db.example.com:5432). If only HOST is provided then the :PORT defaults to :5432 if no value is given. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_name" {
  default     = null
  type        = string
  description = "Name of the PostgreSQL database to store application data in. Required when TFE_OPERATIONAL_MODE is external or active-active."
}

variable "database_parameters" {
  default     = null
  type        = string
  description = "PostgreSQL server parameters for the connection URI. Used to configure the PostgreSQL connection (e.g. sslmode=require)."
}

# Storage
variable "storage_type" {
  default     = null
  type        = string
  description = "Type of object storage to use. Must be one of s3, azure, or google. Required when TFE_OPERATIONAL_MODE is external or active-active."
  validation {
    condition     = contains(["s3", "google", "azure"], var.storage_type)
    error_message = "The storage_type value must be one of: \"s3\"; \"google\"; \"azure\"."
  }
}

variable "s3_access_key_id" {
  default     = null
  type        = string
  description = "S3 access key ID. Required when TFE_OBJECT_STORAGE_TYPE is s3 and TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE is false."
}

variable "s3_secret_access_key" {
  default     = null
  type        = string
  description = "S3 secret access key. Required when TFE_OBJECT_STORAGE_TYPE is s3 and TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE is false."

}

variable "s3_region" {
  default     = null
  type        = string
  description = "S3 region. Required when TFE_OBJECT_STORAGE_TYPE is s3."
}

variable "s3_bucket" {
  default     = null
  type        = string
  description = "S3 bucket name. Required when TFE_OBJECT_STORAGE_TYPE is s3."
}

variable "s3_endpoint" {
  default     = null
  type        = string
  description = "S3 endpoint. Useful when using a private S3 endpoint. Leave blank to use the default AWS S3 endpoint. Defaults to \"\" if no value is given."
}

variable "s3_server_side_encryption" {
  default     = null
  type        = string
  description = "Server-side encryption algorithm to use. Set to aws:kms to use AWS KMS. Leave blank to disable server-side encryption. Defaults to \"\" if no value is given."
}

variable "s3_server_side_encryption_kms_key_id" {
  default     = null
  type        = string
  description = "KMS key ID to use for server-side encryption. Leave blank to use AWS-managed keys. Defaults to \"\" if no value is given."
}

variable "s3_use_instance_profile" {
  default     = null
  type        = string
  description = "Whether to use the instance profile for authentication. Defaults to false if no value is given."
}

variable "azure_account_key" {
  default     = null
  type        = string
  description = "Azure Blob Storage access key. Required when TFE_OBJECT_STORAGE_TYPE is azure and TFE_OBJECT_STORAGE_AZURE_USE_MSI is false."
}

variable "azure_account_name" {
  default     = null
  type        = string
  description = "Azure Blob Storage account name. Required when TFE_OBJECT_STORAGE_TYPE is azure."
}

variable "azure_container" {
  default     = null
  type        = string
  description = "Azure Blob Storage container name. Required when TFE_OBJECT_STORAGE_TYPE is azure."
}

variable "azure_endpoint" {
  default     = null
  type        = string
  description = "Azure Storage endpoint. Useful if using a private endpoint for Azure Stoage. Leave blank to use the default Azure Storage endpoint. Defaults to \"\" if no value is given. "
}

variable "google_bucket" {
  default     = null
  type        = string
  description = "Google Cloud Storage bucket name. Required when TFE_OBJECT_STORAGE_TYPE is google."
}

variable "google_credentials" {
  default     = null
  type        = string
  description = "Google Cloud Storage JSON credentials. Must be given as an escaped string of JSON or Base64 encoded JSON. Leave blank to use the attached service account. Defaults to \"\" if no value is given."
}

variable "google_project" {
  default     = null
  type        = string
  description = "Google Cloud Storage project name. Required when TFE_OBJECT_STORAGE_TYPE is google."
}

# Vault
variable "vault_address" {
  default     = null
  type        = string
  description = "Address of the external Vault server (e.g. https://vault.example.com:8200). Defaults to \"\" if no value is given. Required when TFE_VAULT_USE_EXTERNAL is true."
}

variable "vault_namespace" {
  default     = null
  type        = string
  description = "Vault namespace. External Vault only. Leave blank to use the default namespace. Defaults to \"\" if no value is given."
}

variable "vault_path" {
  default     = null
  type        = string
  description = "Vault path when AppRole is mounted. External Vault only. Defaults to auth/approle if no value is given."
}

variable "vault_role_id" {
  default     = null
  type        = string
  description = "Vault role ID. External Vault only. Required when TFE_VAULT_USE_EXTERNAL is true."
}

variable "vault_secret_id" {
  default     = null
  type        = string
  description = "Vault secret ID. External Vault only. Required when TFE_VAULT_USE_EXTERNAL is true."
}

# Redis
variable "redis_host" {
  default     = null
  type        = string
  description = "The Redis server to connect to in the format HOST[:PORT] (e.g. redis.example.com or redis.example.com:). If only HOST is provided then the :PORT defaults to :6379 if no value is given. Required when TFE_OPERATIONAL_MODE is active-active."
}

variable "redis_user" {
  default     = null
  type        = string
  description = "Redis server user. Leave blank to not use a user when authenticating. Defaults to \"\" if no value is given."
}

variable "redis_password" {
  default     = true
  type        = string
  description = "Redis server password. Required when TFE_REDIS_USE_AUTH is true."
}

variable "redis_use_tls" {
  default     = false
  type        = bool
  description = "Whether or not to use TLS to access Redis. Defaults to false if no value is given."
}

variable "redis_use_auth" {
  default     = null
  type        = bool
  description = "Whether or not to use authentication to access Redis. Defaults to false if no value is given."
}

variable "tfe_license" {
  default     = null
  type        = string
  description = "The HashiCorp license. Defaults to \"\" if no value is given. Required when TFE_LICENSE_PATH is unset."
}

variable "hostname" {
  default     = null
  type        = string
  description = "Hostname where Terraform Enterprise is accessed (e.g. terraform.example.com)."
}

variable "operational_mode" {
  default     = null
  type        = string
  description = "Terraform Enterprise operational mode."
  validation {
    condition = (
      var.operational_mode == "disk" ||
      var.operational_mode == "external" ||
      var.operational_mode == "active-active"
    )

    error_message = "Supported values for operational_mode are 'disk', 'external', and 'active-active'."
  }
}

variable "cert_file" {
  default     = null
  type        = string
  description = "Path to a file containing the TLS certificate Terraform Enterprise will use when serving TLS connections to clients."
}

variable "key_file" {
  default     = null
  type        = string
  description = "Path to a file containing the TLS private key Terraform Enterprise will use when serving TLS connections to clients."
}

variable "license_reporting_opt_out" {
  default     = null
  type        = bool
  description = "Whether to opt out of reporting licensing information to HashiCorp. Defaults to false if no value is given."
}
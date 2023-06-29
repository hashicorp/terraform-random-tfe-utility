# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# General
# -------
variable "cloud" {
  type        = string
  description = "(Required) On which cloud is this Terraform Enterprise installation being deployed?"
  validation {
    condition     = contains(["aws", "azurerm", "google"], var.cloud)
    error_message = "Supported values for cloud are 'aws', 'azurerm', or 'google'."
  }
}

variable "distribution" {
  type        = string
  description = "(Required) What is the OS distribution of the instance on which Terraoform Enterprise will be deployed?"
  validation {
    condition     = contains(["rhel", "ubuntu"], var.distribution)
    error_message = "Supported values for distribution are 'rhel', or 'ubuntu'."
  }
}

variable "tfe_license_secret_id" {
  type        = string
  description = <<-EOD
  The secrets manager secret ID under which the Base64 encoded Terraform Enterprise license is stored.
  NOTE: If this is an airgapped installation, then it is expected that the TFE license will be put
  on the path defined by tfe_license_file_location prior to running this module (i.e. on the virtual machine
  image).
  EOD
}

variable "airgap_url" {
  description = <<-EOD
  The URL of a Replicated airgap package for Terraform Enterprise.
  NOTE: If this value is given, then this script will install the airgap installation prerequisites. The airgap
  bundle should already be on the virtual machine image, and you would not use this variable if this were a truly
  airgapped environment.
  EOD 
  type        = string
}

variable "ca_certificate_secret_id" {
  type        = string
  description = <<-EOD
  A secret ID which contains the Base64 encoded version of a PEM encoded public certificate of a certificate
  authority (CA) to be trusted by the TFE instance(s).
  EOD
}

variable "certificate_secret_id" {
  type        = string
  description = <<-EOD
  A secret ID which contains the Base64 encoded version of a PEM encoded public certificate for the TFE
  instance(s).
  EOD
}

variable "key_secret_id" {
  type        = string
  description = <<-EOD
  A secret ID which contains the Base64 encoded version of a PEM encoded private key for the TFE
  instance(s).
  EOD
}

variable "region" {
  type = string
  nullable = true
  default = null
  description = "Enable this setting to enable log forwarding. This should be the region where your instaces will be deployed for log forwarding."
}

# Proxy
# -----
variable "proxy_ip" {
  type        = string
  description = "IP Address of the proxy server"
}

variable "proxy_port" {
  type        = string
  description = "Port that the proxy server will use"
}

# Settings
# --------
variable "replicated_configuration" {
  description = "The settings that will be used to configure Replicated."
}

variable "tfe_configuration" {
  description = "The settings that will be used to configure Terraform Enterprise."
}

variable "enable_monitoring" {
  type        = bool
  default     = null
  description = <<-EOD
  Should cloud appropriate monitoring agents be installed as a part of the TFE installation
  script? 
  EOD
}

# Added for log forwarding
variable "log_settings" {
  type = object({
    log_destination = string
    # AWS
    cloudwatch_log_group_name  = optional(string) #Cloud Watch
    cloudwatch_log_stream_name = optional(string) #Cloud Watch
    s3_bucket_name             = optional(string) #S3 Bucket
    # Azure
    log_analytics_workspace_id         = optional(string) #Log Analytics Workspace
    log_analytics_workspace_access_key = optional(string) #Log Analytics Workspace
    blob_storage_account_name          = optional(string) #Storage Account
    blob_storage_account_access_key    = optional(string) #Storage Account
    # GCP
    stackdriver_hostname = optional(string) #Stackdriver
  })
  description = "Please see https://developer.hashicorp.com/terraform/enterprise/admin/infrastructure/logging for configuration details."
  nullable    = true
  default     = null
  # Log Destination
  validation {
    condition     = anytrue([
      var.log_settings == null,
      try(contains(["cloudwatch_logs", "s3", "azure", "azure_blob", "stackdriver"], var.log_settings.log_destination),false)
    ])
    error_message = "var.log_settings.log_destination must be 'cloudwatch','s3','azure','azure_blob', or 'stackdriver'"
  }
  # Cloud Watch Logs
  validation {
    condition = (
      anytrue([
        var.log_settings == null,
        try(var.log_settings.log_destination != "cloudwatch_logs",true),
        try(alltrue([
          var.log_settings.cloudwatch_log_group_name != null,
          var.log_settings.cloudwatch_log_stream_name != null
        ]),false)
      ])
    )
    error_message = "var.log_settings.cloudwatch_log_group_name and var.log_settings.cloudwatch_log_stream_name must not be null if var.log_settings.log_destination is 'cloudwatch_logs'"
  }
  # AWS S3 Bucket
  validation {
    condition = (
      anytrue([
        var.log_settings == null,
        try(var.log_settings.log_destination != "s3",true),
        try(var.log_settings.s3_bucket_name != null,false)
      ])
    )
    error_message = "var.log_settings.s3_bucket_name must not be null if var.log_settings.log_destination is 's3'"
  }
  # Azure Log Analytics Workspace
  validation {
    condition = (
      anytrue([
        var.log_settings == null,
        try(var.log_settings.log_destination != "azure",true),
        try(alltrue([
          var.log_settings.log_analytics_workspace_id != null,
          var.log_settings.log_analytics_workspace_access_key != null
        ]),false)
      ])
    )
    error_message = "var.log_settings.log_analytics_workspace_id and log_analytics_workspace_access_key must not be null if var.log_settings.log_destination is 'azure'"
  }
  # Azure Storage Blob
  validation {
    condition = (
      anytrue([
        var.log_settings == null,
        try(var.log_settings.log_destination != "azure_blob",true),
        try(alltrue([
          var.log_settings.blob_storage_account_name != null,
          var.log_settings.blob_storage_account_access_key != null
        ]),false)
      ])
    )
    error_message = "var.log_settings.blob_storage_account_name and blob_storage_account_access_key must not be null if var.log_settings.log_destination is 'azure_blob'"
  }
  # GCP Stackdriver
  validation {
    condition = (
      anytrue([
        var.log_settings == null,
        try(var.log_settings.log_destination != "stackdriver",true),
        try(var.log_settings.stackdriver_hostname != null,false)
      ])
    )
    error_message = "var.log_settings.stackdriver_hostname must not be null if var.log_settings.log_destination is 'stackdriver'"
  }
}

# Mounted Disk
# ------------
variable "disk_device_name" {
  description = "The name of the disk device on which Terraform Enterprise will store data in Mounted Disk mode."
  type        = string
}

variable "disk_path" {
  description = "The pathname of the directory in which Terraform Enterprise will store data in Mounted Disk mode."
  type        = string
}

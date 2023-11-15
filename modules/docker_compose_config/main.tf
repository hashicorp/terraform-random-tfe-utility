# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {

  active_active = var.operational_mode == "active-active"
  disk          = var.operational_mode == "disk"

  compose = {
    version = "3.9"
    name    = "terraform-enterprise"
    services = {
      tfe = {
        image = var.tfe_image
        environment = merge(
          local.database_configuration,
          local.redis_configuration,
          local.storage_configuration,
          local.vault_configuration,
          {
            http_proxy                    = var.http_proxy != null ? "http://${var.http_proxy}" : null
            HTTP_PROXY                    = var.http_proxy != null ? "http://${var.http_proxy}" : null
            https_proxy                   = var.https_proxy != null ? "http://${var.https_proxy}" : null
            HTTPS_PROXY                   = var.https_proxy != null ? "http://${var.https_proxy}" : null
            no_proxy                      = var.no_proxy != null ? join(",", var.no_proxy) : null
            NO_PROXY                      = var.no_proxy != null ? join(",", var.no_proxy) : null
            TFE_DISK_PATH                 = var.disk_path
            TFE_HOSTNAME                  = var.hostname
            TFE_HTTP_PORT                 = var.http_port
            TFE_HTTPS_PORT                = var.https_port
            TFE_OPERATIONAL_MODE          = var.operational_mode
            TFE_ENCRYPTION_PASSWORD       = random_id.enc_password.hex
            TFE_DISK_CACHE_VOLUME_NAME    = "terraform-enterprise_terraform-enterprise-cache"
            TFE_LICENSE_REPORTING_OPT_OUT = var.license_reporting_opt_out
            TFE_LICENSE                   = var.tfe_license
            TFE_TLS_CA_BUNDLE_FILE        = var.tls_ca_bundle_file != null ? var.tls_ca_bundle_file : null
            TFE_TLS_CERT_FILE             = var.cert_file
            TFE_TLS_CIPHERS               = var.tls_ciphers
            TFE_TLS_KEY_FILE              = var.key_file
            TFE_TLS_VERSION               = var.tls_version != null ? var.tls_version : ""
            TFE_RUN_PIPELINE_IMAGE        = var.run_pipeline_image
            TFE_CAPACITY_CONCURRENCY      = var.capacity_concurrency
            TFE_CAPACITY_CPU              = var.capacity_cpu
            TFE_CAPACITY_MEMORY           = var.capacity_memory
            TFE_IACT_SUBNETS              = var.iact_subnets
            TFE_IACT_TIME_LIMIT           = var.iact_time_limit
            TFE_IACT_TRUSTED_PROXIES      = join(",", var.trusted_proxies)
          }
        )
        cap_add = [
          "IPC_LOCK"
        ]
        read_only = true
        tmpfs = [
          "/tmp:mode=01777",
          "/run",
          "/var/log/terraform-enterprise",
        ]
        ports = flatten([
          "80:${var.http_port}",
          "443:${var.https_port}",
          local.active_active ? ["8201:8201"] : []
        ])

        volumes = flatten([
          {
            type   = "bind"
            source = "/var/run/docker.sock"
            target = "/run/docker.sock"
          },
          {
            type   = "bind"
            source = "/etc/tfe/ssl"
            target = "/etc/ssl/private/terraform-enterprise"
          },
          {
            type   = "volume"
            source = "terraform-enterprise-cache"
            target = "/var/cache/tfe-task-worker/terraform"
          },
          local.disk ? [{
            type   = "bind"
            source = var.disk_path
            target = "/var/lib/terraform-enterprise"
          }] : [],
        ])
      }
    }
    volumes = merge(
      { terraform-enterprise-cache = {} },
      local.disk ? { terraform-enterprise = {} } : {}
    )
  }
}

resource "random_id" "enc_password" {
  byte_length = 16
}

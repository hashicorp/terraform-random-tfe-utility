locals {
  base_configs = {
    hostname = {
      value = var.hostname
    }

    installation_type = {
      value = var.installation_type
    }

    production_type = {
      value = var.production_type
    }

    # Alphabetical starting here
    archivist_token = {
      value = random_id.archivist_token.hex
    }

    backup_token = {
      value = var.backup_token
    }

    capacity_concurrency = {
      value = var.capacity_concurrency == null ? null : tostring(var.capacity_concurrency)
    }

    capacity_memory = {
      value = var.capacity_memory == null ? null : tostring(var.capacity_memory)
    }

    capacity_cpus = {
      value = var.capacity_cpus == null ? null : tostring(var.capacity_cpus)
    }

    cookie_hash = {
      value = random_id.cookie_hash.hex
    }

    custom_image_tag = {
      value = var.custom_image_tag
    }

    disk_path = {
      value = var.disk_path
    }

    enc_password = {
      value = var.extern_vault_enable ? null : random_id.enc_password.hex
    }

    extra_no_proxy = {
      value = var.extra_no_proxy == null ? null : join(",", var.extra_no_proxy)
    }

    hairpin_addressing = {
      value = var.hairpin_addressing == true ? "1" : var.hairpin_addressing == false ? "0" : null
    }

    force_tls = {
      value = var.force_tls == true ? "1" : var.force_tls == false ? "0" : null
    }

    iact_subnet_list = {
      value = var.iact_subnet_list == null ? null : join(",", var.iact_subnet_list)
    }

    iact_subnet_time_limit = {
      value = var.iact_subnet_time_limit
    }

    install_id = {
      value = random_id.install_id.hex
    }

    internal_api_token = {
      value = random_id.internal_api_token.hex
    }

    metrics_endpoint_enabled = {
      value = var.metrics_endpoint_enabled == true ? "1" : var.metrics_endpoint_enabled == false ? "0" : null
    }

    metrics_endpoint_port_http = {
      value = var.metrics_endpoint_port_http == null ? null : tostring(var.metrics_endpoint_port_http)
    }

    metrics_endpoint_port_https = {
      value = var.metrics_endpoint_port_https == null ? null : tostring(var.metrics_endpoint_port_https)
    }

    placement = {
      value = (var.production_type == "external" && var.s3_bucket != null) ? "placement_s3" : (
        var.production_type == "external" && var.azure_account_name != null) ? "placement_azure" : (
      var.production_type == "external" && var.gcs_bucket != null) ? "placement_gcs" : null
    }

    registry_session_encryption_key = {
      value = random_id.registry_session_encryption_key.hex
    }

    registry_session_secret_key = {
      value = random_id.registry_session_secret_key.hex
    }

    restrict_worker_metadata_access = {
      value = var.restrict_worker_metadata_access == true ? "1" : var.restrict_worker_metadata_access == false ? "0" : null
    }

    root_secret = {
      value = random_id.root_secret.hex
    }

    tbw_image = {
      value = var.tbw_image
    }

    tls_ciphers = {
      value = var.tls_ciphers
    }
    tls_vers = {
      value = var.tls_vers
    }

    trusted_proxies = {
      value = var.trusted_proxies == null ? null : join(",", var.trusted_proxies)
    }

    user_token = {
      value = random_id.user_token.hex
    }

    vault_store_snapshot = {
      value = var.vault_store_snapshot == true ? "1" : var.vault_store_snapshot == false ? "0" : null
    }
  }
}
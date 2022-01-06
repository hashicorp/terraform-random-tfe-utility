locals {
  base_configs = {
    hostname = {
      value = var.fqdn
    }

    installation_type = {
      value = var.user_data_installation_type
    }

    production_type = {
      value = var.user_data_installation_type == "poc" ? null : "external"
    }

    archivist_token = {
      value = random_id.archivist_token.hex
    }

    cookie_hash = {
      value = random_id.cookie_hash.hex
    }

    enc_password = {
      value = random_id.enc_password.hex
    }

    extra_no_proxy = {
      value = ""
    }

    iact_subnet_list = {
      value = join(",", var.iact_subnet_list)
    }

    install_id = {
      value = random_id.install_id.hex
    }

    internal_api_token = {
      value = random_id.internal_api_token.hex
    }

    registry_session_encryption_key = {
      value = random_id.registry_session_encryption_key.hex
    }

    registry_session_secret_key = {
      value = random_id.registry_session_secret_key.hex
    }

    root_secret = {
      value = random_id.root_secret.hex
    }

    tls_vers = {
      value = "tls_1_2_tls_1_3"
    }

    trusted_proxies = {
      value = join(",", var.user_data_trusted_proxies)
    }

    user_token = {
      value = random_id.user_token.hex
    }
  }
}
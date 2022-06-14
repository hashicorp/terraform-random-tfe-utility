locals {
  external_google_configs = {
    gcs_bucket = {
      value = var.gcs_bucket
    }

    gcs_credentials = {
      value = var.gcs_credentials
    }

    gcs_project = {
      value = var.gcs_project
    }

    gcs_use_instance_sa = {
      value = var.gcs_bucket == null ? null : var.gcs_credentials == null ? "1" : "0"
    }
  }
}

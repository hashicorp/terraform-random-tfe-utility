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
  }
}

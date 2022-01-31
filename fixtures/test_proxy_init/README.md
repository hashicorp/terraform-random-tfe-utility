# Test Proxy Init

This fixture provides initialization scripts for proxy servers which
are used in tests.

The following proxy services are supported:

- mitmproxy
- Squid

As the module only generates the contents of scripts, all proxy
services are unconditionally represented in the module outputs.

Ubuntu on GCP is currently the only supported operating system and
cloud platform combination for the generated initialization scripts.

## Example Usage

Invoking the module for Squid:

```tf
module "test_proxy_init" {
  source = "github.com/hashicorp/terraform-random-tfe-utility//fixtures/test_proxy_init"
}

resource "google_compute_instance" "squid" {
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.id
    }
  }

  name         = "squid"

  metadata_startup_script = module.test_proxy_init.squid.user_data_script

  # Other required and optional arguments...
}
```

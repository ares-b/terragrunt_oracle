terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "5.46.0"
    }
  }
}

provider "oci" {
  tenancy_ocid  = "${tenancy_ocid}"
  user_ocid     = "${user_ocid}"
  fingerprint   = "${fingerprint}"
  private_key   = "${private_key}"
  region        = "${region}"
}

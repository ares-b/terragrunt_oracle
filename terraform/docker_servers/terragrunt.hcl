locals {
    oci_accounts  = {
        account_1 = {
            tenancy_ocid    = "xxxxx"
            user_ocid       = "xxxxx"
            fingerprint     = "xxxxx"
            private_key     = "xxxxx"
            region          = "xxxxx"
        },
        account_2 = {
            tenancy_ocid    = "xxxxx"
            user_ocid       = "xxxxx"
            fingerprint     = "xxxxx"
            private_key     = "xxxxx"
            region          = "xxxxx"
        }
    }    
}

generate "provider" {
    path        = "provider.tf"
    if_exists   = "overwrite_terragrunt"
    contents    = templatefile("../terragrunt_templates/oci_provider.tpl", {
        tenancy_ocid    = local.oci_accounts["${basename(get_terragrunt_dir())}"].tenancy_ocid
        user_ocid       = local.oci_accounts["${basename(get_terragrunt_dir())}"].user_ocid
        fingerprint     = local.oci_accounts["${basename(get_terragrunt_dir())}"].fingerprint
        private_key     = local.oci_accounts["${basename(get_terragrunt_dir())}"].private_key
        region          = local.oci_accounts["${basename(get_terragrunt_dir())}"].region
    })
}

inputs = merge(
    yamldecode(
        file("${get_terragrunt_dir()}/docker_server.yaml"),
    ),
    {
        compartment = {
            parent_compartment_id = local.oci_accounts["${basename(get_terragrunt_dir())}"].tenancy_ocid
        }
    }
)
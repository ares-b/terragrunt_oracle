locals {
    tf_backend    = {
        bucket      = "xxxxx"
        region      = "xxxxx"
        access_key  = "xxxxx"
        secret_key  = "xxxxx"
    }
}

generate "backend" {
    path        = "backend.tf"
    if_exists   = "overwrite_terragrunt"
    contents    = templatefile("terragrunt_templates/s3_backend.tpl", {
        bucket      = local.tf_backend.bucket
        region      = local.tf_backend.region
        key         = "${basename(get_terragrunt_dir())}/terraform.tfstate"
        access_key  = local.tf_backend.access_key
        secret_key  = local.tf_backend.secret_key
    })
}

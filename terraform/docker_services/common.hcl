locals {
    docker_service = yamldecode(
        file("${get_terragrunt_dir()}/docker_service.yaml")
    )
}


dependency "docker_server" {
    config_path = "${get_terragrunt_dir()}/../../docker_servers/${local.docker_service.server}"
}

generate "provider" {
    path        = "provider.tf"
    if_exists   = "overwrite"
    contents    = templatefile("${get_terragrunt_dir()}/../../terragrunt_templates/docker_ssh_provider.tpl", {
        docker_server    = dependency.docker_server.outputs.ip
        private_key      = dependency.docker_server.outputs.privatekey
    })
}

inputs = local.docker_service.service

terraform {
  source = "${get_terragrunt_dir()}/../../modules/docker_service"
}



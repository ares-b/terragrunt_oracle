resource "docker_image" "service_image" {
  name = var.service.image
  keep_locally = false
}

resource "docker_container" "service_container" {
  name  = var.service.name
  image = docker_image.service_image.image_id

  env = [for e in var.service.environment : "${e.name}=${e.value}"]
  
  dynamic "ports" {
    for_each = var.service.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  dynamic "volumes" {
    for_each = var.service.volumes
    content {
      container_path = volumes.value.container_path
      host_path      = volumes.value.host_path
      read_only      = volumes.value.read_only
    }
  }

  privileged    = var.service.privileged
  restart       = var.service.restart_policy
}

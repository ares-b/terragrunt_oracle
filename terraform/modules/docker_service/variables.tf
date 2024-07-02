
variable "service" {
  type = object({
    name            = string
    image           = string
    restart_policy  = optional(string, "on-failure")
    ports           = optional(list(object({
        internal = number
        external = number
    })), [])
    environment     = optional(list(object({
        name    = number
        value   = number
    })), [])
    volumes         = optional(list(object({
        container_path = string
        host_path      = string
        read_only      = optional(bool, false)
    })), [])
    privileged      = optional(bool, false)
  })
}
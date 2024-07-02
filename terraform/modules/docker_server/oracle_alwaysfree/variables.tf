# Compartment

variable "compartment" {

    type = object({
        parent_compartment_id   = string
        name                    = optional(string, "alwaysfree")
        description             = optional(string, "Compartment for Always Free Resources")
    })

}

# Network

variable "vcn" {

    type = object({
        cidr_block          = string
        display_name        = string
        dns_label           = optional(string)
    })

    default = {
        cidr_block          = "10.0.0.0/16"
        display_name        = "alwaysfree_vcn"
    }

    validation {
        condition = can(
            length(var.vcn.dns_label) >= 1 && length(var.vcn.dns_label) <= 15
        ) || var.vcn.dns_label == null
        error_message = "If provided, dns_label must be a string with a length between 1 and 15."
    }
}

variable "igw" {

    type = object({
        display_name    = string
        enabled         = bool
    })

    default = {
        display_name    = "alwaysfree_igw"
        enabled         = true
    }

}

variable "route_table" {

    type = object({
        display_name    = string
        enabled         = bool
    })

    default = {
        display_name    = "alwaysfree_igw"
        enabled         = true
    }

}

variable "subnet" {

    type = object({
        cidr_block                  = string
        display_name                = string
        dns_label                   = optional(string)
        prohibit_public_ip_on_vnic  = bool
    })

    default = {
        cidr_block                  = "10.0.0.0/24"
        display_name                = "alwaysfree_subnet"
        prohibit_public_ip_on_vnic  = false
    }

    validation {
        condition = can(
            length(var.subnet.dns_label) >= 1 && length(var.subnet.dns_label) <= 15
        ) || var.subnet.dns_label == null
        error_message = "If provided, dns_label must be a string with a length between 1 and 15."
    }
}

variable "ingress_rules" {

    type = list(object({
        protocol  = string
        source    = string
        min_port  = number
        max_port  = number
    }))

    default = []

}

# Compute

variable "compute" {

    type = object({
        shape                   = string
        ocpus                   = number
        memory_in_gbs           = number
        ssh_public_key          = optional(string)
        os                      = string
        os_version              = string
        boot_volume_size_in_gbs = number
    })

    default = {
        shape                   = "VM.Standard.A1.Flex"
        ocpus                   = 4
        memory_in_gbs           = 24
        os                      = "Canonical Ubuntu"
        os_version              = "22.04"
        boot_volume_size_in_gbs = 200
    }
}
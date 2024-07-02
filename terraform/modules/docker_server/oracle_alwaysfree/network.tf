resource "oci_core_vcn" "alwaysfree_vcn" {
  compartment_id   = oci_identity_compartment.alwaysfree_compartment.id
  cidr_block      = var.vcn.cidr_block
  display_name    = var.vcn.display_name
  dns_label       = var.vcn.dns_label
}

resource "oci_core_internet_gateway" "alwaysfree_igw" {
  compartment_id = oci_identity_compartment.alwaysfree_compartment.id
  vcn_id         = oci_core_vcn.alwaysfree_vcn.id
  display_name   = var.igw.display_name
  enabled        = var.igw.enabled
}

resource "oci_core_route_table" "alwaysfree_route_table" {
  compartment_id = oci_identity_compartment.alwaysfree_compartment.id
  vcn_id         = oci_core_vcn.alwaysfree_vcn.id

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.alwaysfree_igw.id
  }
}

resource "oci_core_security_list" "alwaysfree_security_list" {
  compartment_id = oci_identity_compartment.alwaysfree_compartment.id
  vcn_id         = oci_core_vcn.alwaysfree_vcn.id
  display_name   = "alwaysfree_security_list"

  dynamic "ingress_security_rules" {
    for_each = var.ingress_rules
    content {
      protocol = ingress_security_rules.value.protocol
      source   = ingress_security_rules.value.source
      tcp_options {
        min = ingress_security_rules.value.min_port
        max = ingress_security_rules.value.max_port
      }
    }
  }

  egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "alwaysfree_subnet" {
  compartment_id                = oci_identity_compartment.alwaysfree_compartment.id
  vcn_id                        = oci_core_vcn.alwaysfree_vcn.id
  cidr_block                    = var.subnet.cidr_block
  display_name                  = var.subnet.display_name
  dns_label                     = var.subnet.dns_label
  prohibit_public_ip_on_vnic    = var.subnet.prohibit_public_ip_on_vnic
  route_table_id                = oci_core_route_table.alwaysfree_route_table.id
  security_list_ids             = [
    oci_core_security_list.alwaysfree_security_list.id
  ]
}

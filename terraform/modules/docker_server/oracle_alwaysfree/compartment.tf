resource "oci_identity_compartment" "alwaysfree_compartment" {
  compartment_id  = var.compartment.parent_compartment_id
  description     = var.compartment.description
  name            = var.compartment.name
}

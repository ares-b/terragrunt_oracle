resource "random_password" "${name}" {
  length  = ${length}
  special = ${special}
}
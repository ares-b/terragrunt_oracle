output "ip" {
  value = module.oracle_alwaysfree.alwaysfree_instance_ip
}

output "privatekey" {
  value = module.oracle_alwaysfree.alwaysfree_instance_privatekey
  sensitive = true
}

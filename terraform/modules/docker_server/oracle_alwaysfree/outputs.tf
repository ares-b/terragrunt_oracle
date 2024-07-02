output "alwaysfree_user" {
  value = "ubuntu"
}

output "alwaysfree_instance_ip" {
  value = oci_core_instance.alwaysfree_instance.public_ip
}

output "alwaysfree_instance_privatekey" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "alwaysfree_instance_publickey" {
  value = tls_private_key.ssh_key.public_key_openssh
}

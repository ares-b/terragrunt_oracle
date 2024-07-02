
module "oracle_alwaysfree" {
  source             = "./oracle_alwaysfree"
  
  compartment           = var.compartment
  vcn                   = var.vcn
  igw                   = var.igw
  route_table           = var.route_table
  subnet                = var.subnet
  ingress_rules         = var.ingress_rules
  compute               = var.compute
}

resource "null_resource" "ansible_provisioner" {

  # Wait for SSH Agent
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oracle_alwaysfree.alwaysfree_instance_ip
      user        = module.oracle_alwaysfree.alwaysfree_user
      private_key = module.oracle_alwaysfree.alwaysfree_instance_privatekey
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    environment = {
      ANSIBLE_CONFIG = "${path.root}/../ansible/ansible.cfg"
    }
    command = <<EOT
        # Write private key to a file
        echo "${module.oracle_alwaysfree.alwaysfree_instance_privatekey}" > private_key_${module.oracle_alwaysfree.alwaysfree_instance_ip}.pem
        chmod 600 private_key_${module.oracle_alwaysfree.alwaysfree_instance_ip}.pem
        
        # Define the variables to pass to Ansible
        VARIABLES_JSON='{
          "managed_groups": ${jsonencode(concat(local.managed_groups, var.managed_groups))},
          "managed_users": ${jsonencode(concat(local.managed_users, var.managed_users))}
        }'
        echo "$VARIABLES_JSON" > variables_${module.oracle_alwaysfree.alwaysfree_instance_ip}.json

        # Run the Ansible playbook with verbose logging
        ansible-playbook -u ${module.oracle_alwaysfree.alwaysfree_user} \
        --private-key private_key_${module.oracle_alwaysfree.alwaysfree_instance_ip}.pem \
        -i ${module.oracle_alwaysfree.alwaysfree_instance_ip}, \
        -e @variables_${module.oracle_alwaysfree.alwaysfree_instance_ip}.json \
        ${path.root}/../ansible/configure_docker_host.yml
        
        # Capture the exit status
        ANSIBLE_EXIT_STATUS=$?

        # Clean everything
        

        # Exit with the Ansible exit status
        exit $ANSIBLE_EXIT_STATUS
        EOT
  }

}

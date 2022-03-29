output "ldap_server_ssh" {
  value = "Type this in on a terminal to SSH connection to web server: ssh -i ${module.local.server_filename} ec2-user@${module.ec2.server_ssh_pub_ip}"
}

output "ldap_client_ssh" {
  value = "Type this in on a terminal to SSH connection to web server: ssh -i ${module.local.client_filename} ec2-user@${module.ec2.client_ssh_pub_ip}"
}
output "server_ssh_pub_ip" {
  value = aws_instance.ldap_server.public_ip
}

output "client_ssh_pub_ip" {
  value = aws_instance.ldap_client.public_ip
}
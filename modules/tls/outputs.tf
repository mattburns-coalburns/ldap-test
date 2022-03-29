###############################
#        LDAP   SERVER        #
###############################

output "ldap-server-private-key" {
  value = tls_private_key.ldap_server.private_key_pem
}

output "ldap-server-public-key" {
  value = tls_private_key.ldap_server.public_key_openssh
}

###############################
#        LDAP   CLIENT        #
###############################

output "ldap-client-private-key" {
  value = tls_private_key.ldap_client.private_key_pem
}

output "ldap-client-public-key" {
  value = tls_private_key.ldap_client.public_key_openssh
}
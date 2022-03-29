###############################
#        LDAP   SERVER        #
###############################

resource "local_file" "ldap_server" {
  filename        = "ldap_server.pem"
  file_permission = 0400
  content         = var.ldap-server-private-key
}

###############################
#        LDAP   CLIENT        #
###############################

resource "local_file" "ldap_client" {
  filename        = "ldap_client.pem"
  file_permission = 0400
  content         = var.ldap-client-private-key
}
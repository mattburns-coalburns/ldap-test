###############################
#        LDAP   SERVER        #
###############################

resource "tls_private_key" "ldap_server" {
  algorithm   = "RSA"
  ecdsa_curve = "4096"
}

###############################
#        LDAP   CLIENT        #
###############################

resource "tls_private_key" "ldap_client" {
  algorithm   = "RSA"
  ecdsa_curve = "4096"
}
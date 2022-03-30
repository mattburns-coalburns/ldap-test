###############################
#        LDAP   SERVER        #
###############################

# Provides Public key for LDAP Server
resource "aws_key_pair" "ldap_server" {
  key_name   = "ldap_server"
  public_key = var.ldap-server-public-key
}

# Provides LDAP Server instance, which is managed via SSH
resource "aws_instance" "ldap_server" {
  ami                         = var.ami
  subnet_id                   = var.sub2_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.pub_ssh_sg]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ldap_server.key_name

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname ldap_server.local
    yum update -y
    yum install -y openldap-servers openldap-clients
    systemctl start slapd
    

    EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.base_name}_ldap_server"
  }
}

###############################
#        LDAP   CLIENT        #
###############################

# Provides Public key for LDAP Client
resource "aws_key_pair" "ldap_client" {
  key_name   = "ldap_client"
  public_key = var.ldap-client-public-key
}

# Provides LDAP Client, which is managed via SSH
resource "aws_instance" "ldap_client" {
  ami                         = var.ami
  subnet_id                   = var.sub2_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.pub_ssh_sg]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ldap_client.key_name

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname ldap_client.local
    yum update -y
    yum install -y openldap-clients nss-pam-ldpad

    EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.base_name}_ldap_client"
  }
}
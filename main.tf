# --- ./main.tf --- 

# Invokes VPC module
module "vpc" {
  source    = "./modules/vpc"
  base_name = var.base_name
}

# Invokes EC2 module
module "ec2" {
  source                 = "./modules/ec2"
  base_name              = var.base_name
  sub2_id                = module.vpc.sub2
  pub_ssh_sg             = module.vpc.pub_ssh_sg
  ldap-server-public-key = module.tls.ldap-server-public-key
  ldap-client-public-key = module.tls.ldap-client-public-key
}

# Invokes TLS Module
module "tls" {
  source = "./modules/tls"
}

# Invokes Locals Module
module "local" {
  source              = "./modules/local"
  ldap-server-private-key = module.tls.ldap-server-private-key
  ldap-client-private-key = module.tls.ldap-client-private-key
}
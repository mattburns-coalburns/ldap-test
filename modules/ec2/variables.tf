variable "base_name" {
  type        = string
  description = "The base name for the EC2 instance"
}

variable "ami" {
  type        = string
  default     = "ami-0c02fb55956c7d316"
  description = "The AMI for the EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The Instance Type for the EC2 instance"
}

variable "sub2_id" {
  type        = string
  description = "The ID of subnet 2, from the VPC Module"

}

variable "pub_ssh_sg" {}

variable "ldap-server-public-key" {}

variable "ldap-client-public-key" {}
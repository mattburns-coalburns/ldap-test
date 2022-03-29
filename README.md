# LDAP Test
## About
This is a Terraform lab environment I built to learn LDAP Server and Client configuration as a prerequisite to configuring a Cisco ASAv instance as an LDAP client, using Google Workspaces (formerly "G-Suite") as the LDAP Server. </br>
A `terraform apply --auto-approve` builds a complete Virtual Private Cloud (VPC) with two EC2 instances. </br>
- One Amazon Linux 2 instance configured as an LDAP Server
- One Amazon Linux 2 instance configured as an LDAP Client

## Deliverables
Once this infrastructure is deployed, output values are provided so you can test it out:</br>
1. Two private .pem files will be installed in the directory you run `terraform apply` from.
2. The complete command strings to open a terminal session to the EC2 instances
**NOTE**: While User Data is running, some services may take up to 5 minutes to fully provision.</br>
Try a few minutes, and try again.

## Network Diagram
TBD

## Resources:
- VPC (in US-East-1)
- Subnet (Public)
- Two EC2 Instances (Public IPs included)
- SSH-Public Security Group
- Local SSH keys

## References used:
https://acloudguru.com/course/linux-network-client-management </br>
https://support.google.com/a/answer/9048516?hl=en </br>
https://www.watchguard.com/help/docs/help-center/en-US/Content/Integration-Guides/AuthPoint/Google-Workspace-LDAP-sync_authpoint.html</br>
https://support.google.com/a/answer/106368?hl=en</br>
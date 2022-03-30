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

## Instructions
1. From the terminal of your favorite IDE, `git clone https://github.com/mattburns-coalburns/ldap-test.git`
2. Run `terraform apply --auto-approve`
3. Outputs include the complete command strings to open a terminal session to the EC2 instances.

### LDAP Server Configuration
1. Log in to `ldap_server` using the command string output by Terraform `terraform apply`.
2. Switch to root user: `sudo su -`
3. On `ldap_server`, verify that the server daemon is listening for LDAP requests with `netstat -tulpen | grep -i 389`. If output shows something like this then you're good:
```
tcp   0   0 0.0.0.0:389  0.0.0.0:*  LISTEN  0  21582  -         
tcp6  0   0 :::389       :::*       LISTEN  0  21583  -
```
#### OpenLDAP Configuration
4. Change to the slapd directory: `cd /etc/openldap/slapd.d`
5. Run an `ls` to list the folder contents. You should see an LDIF file with the `.ldif` extension. Let's look at it's contents with `more *.ldif`. There you will see the sample LDIF file / LDAP configuration that was created when the server installed OpenLDAP during Terraform Apply.
6. You will not modify the `.ldif` directly. OpenLDAP provides configuration tools to do that for us.
7. Let's generate an LDAP root password: `slappasswd`, then enter the password of your choosing.
8. Copy the **entire line** of the encrypted password (starts with `{SSHA}`)
9. Move back to the home directory: `cd ~`
10. Let's create an `.ldif` file to add some configuration items to our database: </br>
- `vim db.ldif`
- Press `i` to enter Insert mode.
- Copy and paste this into the file contents:
```
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=mylabserver,dc=local

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=ldapadm,dc=mylabserver,dc=local

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}<REPLACE-ME-WITH-VALUE-FROM-STEP-8>
```
- Save the file by pressing Esc, then `:`, then type `wq`, then Enter.
11. Run another `ls /etc/openldap/slapd.d`.  Note that additional files will be loaded here when a new `.ldif` file is loaded.
12. Also, if you do an `ls /etc/openldap`, note the `ldap.conf` file. This is used to set the system-wide defaults that are applied when running LDAP client tools, such as `ldapsearch` and `ldapadd`. But this isn't to be confused for the main configuration file for `slapd`, which is `slapd.conf`, or the `slapd.d` configuration directory.
13. Now let's modify the LDAP server with `ldapmodify -Y EXTERNAL -H ldapi:/// -f db.ldif`
14. Now we'll create another file called `monitor.ldif`: 
- `vim monitor.ldif`
- Press `i` to enter Insert mode.
- Copy and paste this into the file contents:
```
dn: olcDatabase={1}monitor,cn=config
changetype:modify
replace:olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="cn=ldapadm,dc=example,dc=local" read by * none
```
- Save the file by pressing Esc, then `:`, then type `wq`, then Enter.
15. Add this file to the LDAP Database with `ldapmodify -Y EXTERNAL -H ldapi:/// -f monitor.ldif`
16. Set up the LDAP database and copy the example configuration file over to /var/lib/ldap: `cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG`
17. Change the owner to `ldap:ldap` with `chown ldap:ldap /var/lib/ldap/DB_CONFIG`
18. Add some schemas: 
- Cosine: `ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif`
- NIS: `ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif`
- inetOrgPerson: `ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif`
19. Create a base file: `vim base.ldif`:
- `vim base.ldif`
- Press `i` to enter Insert mode.
- Copy and paste this into the file contents:
```
dn: dc=mylabserver,dc=local
dc: mylabserver
objectClass: top
objectClass: domain

dn: cn=ldapadm,dc=mylabserver,dc=local
objectClass: organizationalRole
cn: ldapadm
description: LDAP Admin

dn: ou=People,dc=mylabserver,dc=local
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=mylabserver,dc=local
objectClass: organizationalUnit
ou: Group
```
- Save the file by pressing Esc, then `:`, then type `wq`, then Enter.
20. Use this file to create our Directory structure: `ldapadd -x -W -D "cn=ldapadm,dc=mylabserver,dc=local" -f base.ldif`
21. Enter your LDAP password you configured in Step 7 and hit Enter. You can see that three new Entries were added to the database.

#### OpenLDAP User Configuration
22. Let's configure an LDAP User:
- `vim /root/john.ldif`
- Press `i` to enter Insert mode.
- Copy and paste this into the file contents:
```
dn: uid=john,ou=People,dc=mylabserver,dc=local
objectClass: top
objectClass: account 
objectClass: posixAccount 
objectClass: shadowAccount 
cn: john 
uid: john 
uidNumber: 1100 
gidNumber: 1100 
homeDirectory: /home/john 
loginShell: /bin/bash 
gecos: John Smith 
userPassword: {crypt}x 
shadowLastChange: 17058 
shadowMin: 0 
shadowMax: 99999
shadowWarning: 7 
```
- Save the file by pressing Esc, then `:`, then type `wq`, then Enter.
23. Add this LDIF file to the LDAP Server: 
- `ldapadd -x -W -D "cn=ldapadm,dc=mylabserver,dc=local" -f john.ldif`
- **DANG IT I CAN'T GET THIS TO WORK....**
- error message is as follows:
```
[root@ldap_server ~]# ldapadd -x -W -D "cn=ldapadm,dc=mylabserver,dc=local" -f john.ldif 
Enter LDAP Password: 
adding new entry "uid=john,ou=People,dc=mylabserver,dc=local"
ldap_add: Invalid syntax (21)
        additional info: objectClass: value #1 invalid per syntax
```
- Stopping here.... will research more later.


### LDAP Client Configuration

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
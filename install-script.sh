#!/bin/bash
# Alround server for managing services
# Services: ldap, postfix, dovecot, webserver, monitoring

### USER SETTINGS ###########
ldappass="NoFoobar01"
dcprim="local"
dcsec="gamers-congress"
#############################

epel="https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
packages="nagios rrdtool nagios-plugins-all net-snmp-utils openldap-servers openldap-clients phpldapadmin dovecot httpd php bind pnp4nagios mod_python"

rpm -ivh $epel
yum update -y -y
yum install $packages -y -y
sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
setenforce 0
chkconfig iptables off

#Configure bind
rndc-confgen -a -r /dev/urandom

#Configure services
which systemctl
if [ $? = 0 ]; then
  systemctl enable nagios.service
  systemctl enable named.service
  systemctl enable httpd.service
  systemctl enable slapd.service

  systemctl start nagios.service
  systemctl start named.service
  systemctl start httpd.service
  systemctl start slapd.service
else
  chkconfig nagios on
  chkconfig named on
  chkconfig httpd on
  chkconfig slapd on
  
  service nagios start
  service named start
  service httpd start
  service slapd start
fi


#Configure ldap
slappasswd -s $ldappass > /tmp/slap
cat /etc/openldap/slap.d/cn\=config/olcDatabase\=\{2\}bdb.ldif | grep olcRootPW
if [ $? = 0 ]; then
  sed -i 's/olcRootPW:/olcRootPW:`cat /tmp/slap`/g' /etc/openldap/slap.d/cn\=config/olcDatabase\=\{2\}bdb.ldif
else
  echo "olcRootPW:`cat /tmp/slap` >> /etc/openldap/slap.d/cn\=config/olcDatabase\=\{2\}bdb.ldif
fi

sed -i 's/dc=my-domain,dc=com/dc=$dcsec,dc=$dcprim/g' /etc/openldap/slap.d/cn\=config/olcDatabase\=\{2\}bdb.ldif

  

#Configure postfix

#Configure dovecot

#Configure nagios and cmk

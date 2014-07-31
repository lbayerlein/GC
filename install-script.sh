#!/bin/bash
# Alround server for managing services
# Services: ldap, postfix, dovecot, webserver, monitoring

epel="https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
packages="nagios rrdtool nagios-plugins-all net-snmp-utils openldap-servers openldap-clients phpldapadmin dovecot httpd php bind pnp4nagios mod_python"

rpm -ivh $epel
yum update -y -y
yum install $packages
sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
setenforce 0
chkconfig iptables off

#Configure services
systemctl enable nagios.service
systemctl enable named.service
systemctl enable httpd.service
systemctl enable slapd.service

systemctl start nagios.service
systemctl start named.service
systemctl start httpd.service
systemctl start slapd.service

#Configure ldap

#Configure postfix

#Configure dovecot

#Configure nagios and cmk

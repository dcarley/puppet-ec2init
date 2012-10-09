#!/bin/bash
CERTNAME=`awk '/certname/ {print $3}' /etc/puppet/puppet.conf`

if [ -f /var/lib/puppet/ssl/certificate_requests/${CERTNAME}.pem ]; then  
  rm -f /var/lib/puppet/ssl/certificate_requests/${CERTNAME}.pem                         
fi

/sbin/service puppet restart

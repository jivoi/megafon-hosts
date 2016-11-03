#!/bin/bash
# add ad hosts to /etc/dnsmasq.hosts
if test -s /tmp/hosts_list.*
then
    rm -f /tmp/hosts_list.*
fi
wget --no-check-certificate -O /tmp/hosts_list.1 http://hosts-file.net/ad_servers.txt &&
wget --no-check-certificate -O /tmp/hosts_list.2 https://adaway.org/hosts.txt &&
cat /tmp/hosts_list.* | grep -v ^# | sort -u > /etc/dnsmasq.hosts &&
rm -f /tmp/hosts_list.* &&
/bin/systemctl reload dnsmasq
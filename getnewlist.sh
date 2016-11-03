#!/bin/bash

#DIR=$(dirname $(readlink -f $0))
DIR="."

whitelist="localhost|metrika|analytics|c.allegrostatic.pl|odnoklassniki.ru|no-ip.com|vk.cc|db.tt|aliexpress|clck.ru|j.mp"

###################################################################################
rm -f dbpart-*
wget -qO - "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&startdate[day]=&startdate[month]=&startdate[year]=" | egrep -v "^#" | grep 127.0.0.1 | awk '{print $2}' > yoyo.txt
wget -qO - http://winhelp2002.mvps.org/hosts.txt | egrep -v "^#" | grep 0.0.0.0 | awk '{print $2}' > mvps.txt
wget -qO - http://malware-domains.com/files/domains.zip | gunzip | egrep -v "^#" | awk '{print $2}'> malwaredomains.txt
wget -qO - http://adaway.org/hosts.txt | egrep -v "^#" | grep 127.0.0.1 | awk '{print $2}'> adaway.txt
#wget -qO - http://www.malwaredomainlist.com/mdlcsv.php | egrep -v "^#" | awk -F"," '{print $2}' | sed 's/"//g' | awk -F"/" '{print $1}' | awk -F":" '{print $1}' | sort -u | grep -v "-" | egrep -v "^$" > malwaredomainlist.txt
wget -qO - http://someonewhocares.org/hosts/hosts | egrep -v "^#" | grep 127.0.0.1 | awk '{print $2}' > danpollock.txt
wget -q    http://hosts-file.net/download/hosts.zip
unzip hosts.zip hosts.txt > /dev/null
cat hosts.txt | egrep -v "^#" | grep 127.0.0.1 | awk '{print $2}' > hphosts.txt
rm -f hosts.zip hosts.txt

cat *.txt | sed 's/\r$//' | tr '[:upper:]' '[:lower:]' | sed 's/\.$//g'  | sort -u | uniq | egrep -v "^$" | egrep -v "^-" | egrep -v "${whitelist}" | awk '{print "zone \""$1"\" { type master; notify no; file \"./db.null\"; };"}' > ${DIR}/named.conf.adblock-silvergh0st
rm -f *.txt

# zone2sql --gmysql --transactions --named-conf=./named.conf > zones.sql
# split -l 200000 ./zones.sql ./dbpart-
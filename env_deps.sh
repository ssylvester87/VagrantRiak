#!/usr/bin/env bash

touch provision.log
chown vagrant provision.log
chgrp vagrant provision.log

echo "+++ Provision started +++" >> provision.log
date >> provision.log

cat <<EOF >> /etc/security/limits.conf

*               soft     nofile          65536
*               hard     nofile          65536
EOF

cat <<EOF >> ~vagrant/.profile

CLIENT_LIBRARY_PATH=~/riak-erlang-client
PATH=.:~vagrant/riak-$1/dev/dev1/bin:$PATH
EOF

echo "Install ftp server"
echo -e "\n\n+++ Install ftp server +++" >> provision.log
apt-get install vsftpd >> provision.log 2>&1

echo "Install Ubuntu dependency packages"
echo -e "\n\n+++ Install Ubuntu dependency packages +++" >> provision.log
apt-get install --assume-yes build-essential libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev >> provision.log 2>&1

echo "Install PAM for Ubuntu"
echo -e "\n\n+++ Install PAM for Ubuntu +++" >> provision.log
apt-get install libpam0g-dev >> provision.log 2>&1

echo "Install SSL for Ubuntu"
echo -e "\n\n+++ Install SSL for Ubuntu +++" >> provision.log
apt-get install libssl0.9.8 >> provision.log 2>&1

echo "Install Riak dependencies"
echo -e "\n\n+++ Install Riak dependencies +++" >> provision.log
apt-get update >> provision.log 2>&1
apt-get install --assume-yes build-essential libc6-dev-i386 git >> provision.log 2>&1

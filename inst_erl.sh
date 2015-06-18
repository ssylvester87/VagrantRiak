#!/usr/bin/env bash

cd $1

echo "Install Erlang"
echo -e "\n\n+++ Install Erlang +++" >> ../provision.log
make install >> ../provision.log 2>&1

#!/usr/bin/env bash

echo "Download Erlang source"
echo -e "\n\n+++ Download Erlang source +++" >> provision.log
wget http://s3.amazonaws.com/downloads.basho.com/erlang/$1.tar.gz >> provision.log 2>&1

echo "Untar Erlang source"
echo -e "\n+++ Untar Erlang source +++" >> provision.log
tar zxvf $1.tar.gz >> provision.log 2>&1
rm $1.tar.gz

mkdir -p erlmods/beam

cd $1

echo "Configure build environment"
echo -e "\n\n+++ Configure build environment +++" >> ../provision.log
./configure >> ../provision.log 2>&1

echo "Build Erlang manually from source"
echo -e "\n\n+++ Build Erlang manually from source +++" >> ../provision.log
make >> ../provision.log 2>&1

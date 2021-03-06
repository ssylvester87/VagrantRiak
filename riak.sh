#!/usr/bin/env bash

echo "Download Riak source"
echo -e "\n\n+++ Download Riak source +++" >> provision.log
wget http://s3.amazonaws.com/downloads.basho.com/riak/$1/$2/riak-$2.tar.gz >> provision.log 2>&1

echo "Untar Riak source"
echo -e "\n+++ Untar Riak source +++" >> provision.log
tar zxvf riak-$2.tar.gz >> provision.log 2>&1
rm riak-$2.tar.gz

cd riak-$2

echo "Build Riak manually from source"
echo -e "\n\n+++ Build Riak manually from source +++" >> ../provision.log
make rel >> ../provision.log 2>&1

echo -e "\n\n+++ Open files system limit +++" >> ../provision.log
ulimit -n >> ../provision.log

echo "Start a single-node cluster"
echo -e "\n\n+++ Start a single-node cluster +++" >> ../provision.log
rel/riak/bin/riak start
rel/riak/bin/riak ping >> ../provision.log 2>&1

echo "View the status of the node in the cluster"
echo -e "\n\n+++ View the status of the node in the cluster +++" >> ../provision.log
rel/riak/bin/riak-admin member-status >> ../provision.log 2>&1

echo "Create a $3-node cluster"
echo -e "\n\n+++ Create a $3-node cluster +++" >> ../provision.log
make devrel DEVNODES=$3 >> ../provision.log 2>&1

cd dev

echo "Start the nodes"
echo -e "\n\n+++ Start the nodes +++" >> ../../provision.log
for node in dev*; do $node/bin/riak start; done
for node in dev*; do $node/bin/riak ping; done >> ../../provision.log 2>&1

echo "Stage the nodes to be joined"
echo -e "\n\n+++ Stage the nodes to be joined +++" >> ../../provision.log
for node in $(seq 2 $3); do dev$node/bin/riak-admin cluster join dev1@127.0.0.1; done >> ../../provision.log 2>&1

echo "View the planned cluster changes"
echo -e "\n\n+++ View the planned cluster changes +++" >> ../../provision.log
dev1/bin/riak-admin cluster plan >> ../../provision.log 2>&1

echo "Commit the staged node joins to the cluster"
echo -e "\n+++ Commit the staged node joins to the cluster +++" >> ../../provision.log
dev2/bin/riak-admin cluster commit >> ../../provision.log 2>&1

echo "View the status of the nodes in the cluster"
echo -e "\n\n+++ View the status of the nodes in the cluster +++" >> ../../provision.log
dev1/bin/riak-admin member-status >> ../../provision.log 2>&1

cd ../..

echo "Download Riak-Erlang client source"
echo -e "\n\n+++ Download Riak-Erlang client source +++" >> provision.log
git clone git://github.com/basho/riak-erlang-client.git
cd riak-erlang-client
git checkout $4 >> ../provision.log 2>&1

echo "Build Riak-Erlang client manually from source"
echo -e "\n\n+++ Build Riak-Erlang client manually from source +++" >> ../provision.log
make >> ../provision.log 2>&1

echo -e "\n\n+++ Provision ended +++" >> ../provision.log
date >> ../provision.log

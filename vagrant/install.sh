#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive
apt-get update > /dev/null
apt-get --yes install git rabbitmq-server postgresql-9.1

cd /tmp
wget http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/4.1.0/solr-4.1.0.tgz
cd ~
tar xzvf /tmp/solr-4.1.0.tgz


rm -rf -- openspending-installer
git clone https://github.com/openspending/openspending-installer

./openspending-installer/install \
	--db-user openspending \
	--solr-dir solr-4.1.0

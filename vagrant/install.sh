#!/bin/bash

set -eu
set -x

#SOLR_URL=http://archive.apache.org/dist/lucene/solr/4.1.0/solr-4.1.0.tgz
SOLR_URL=http://mk.ucant.org/media/solr-4.1.0-smaller.tgz
SOLR_TGZ=/tmp/solr-4.1.0-smaller.tgz

export DEBIAN_FRONTEND=noninteractive
apt-get update > /dev/null
apt-get --yes install git rabbitmq-server postgresql-9.1 \
	python-virtualenv python-dev \
	libxslt1-dev postgresql-server-dev-9.1 \
	make

$(dirname $0)/fix-pg-auth

if ! [ "$TRAVIS" -o "$CI" ]; then
	fix_pghba && /etc/init.d/postgreql restart \
		|| (cat /etc/postgresql/9.1/main/pg_hba.conf; false)
fi

(cd /tmp; wget $SOLR_URL)
(cd ~; tar xzf $SOLR_TGZ)

sudo -u postgres createuser -s openspending
sudo -u postgres psql -c "alter user openspending password 'openspending';"

rm -rf -- openspending-installer
git clone https://github.com/openspending/openspending-installer

./openspending-installer/install \
	--db-user openspending \
	--solr-dir ~/solr-4.1.0 \
	--no-virtualenv \
	--no-clone

# this probably ought to be in a different location

rm -f test.ini
sed 's/:18983/:8983/' < test.ini_tmpl > test.ini

$(dirname $0)/boot-solr &

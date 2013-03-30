#!/bin/bash

set -eu
set -x

#SOLR_URL=http://archive.apache.org/dist/lucene/solr/4.1.0/solr-4.1.0.tgz
SOLR_URL=http://mk.ucant.org/media/solr-4.1.0-smaller.tgz
SOLR_TGZ=/tmp/solr-4.1.0-smaller.tgz

install-packages () {
	export DEBIAN_FRONTEND=noninteractive
	apt-get update > /dev/null
	apt-get --yes install git rabbitmq-server postgresql-9.1 \
		python-virtualenv python-dev \
		libxslt1-dev postgresql-server-dev-9.1 \
		make
}

do-fix-pg-auth () {
	$(dirname $0)/fix-pg-auth
}

start-postgres () {
	if ! [ "$TRAVIS" -o "$CI" ]; then
		do-fix-pg-auth && /etc/init.d/postgreql restart \
			|| (cat /etc/postgresql/9.1/main/pg_hba.conf; false)
	fi
}

install-solr () {
	(cd /tmp; wget -O $SOLR_TGZ $SOLR_URL)
	(cd ~; tar xzf $SOLR_TGZ)
}

setup-postgres-users () {
	sudo -u postgres createuser -s openspending
	sudo -u postgres psql -c "alter user openspending password 'openspending';"
}

install-os-installer () {
	rm -rf -- openspending-installer
	git clone https://github.com/openspending/openspending-installer
}

run-os-installer () {
	./openspending-installer/install \
		--db-user openspending \
		--solr-dir ~/solr-4.1.0 \
		--no-virtualenv \
		--no-clone
}

# this probably ought to be in a different location

setup-test-ini () {
	$(dirname $0)/setup-test.ini
}

boot-solr () {
	$(dirname $0)/boot-solr &
}

install-packages
start-postgres
install-solr
setup-postgres-users
install-os-installer
run-os-installer
setup-test-ini
boot-solr
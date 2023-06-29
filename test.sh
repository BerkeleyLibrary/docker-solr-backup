#!/bin/sh -e

function cleanup {
    docker compose down -v
}
trap cleanup EXIT

function existing_snapshots() {
    docker compose exec solr find /var/solr/data -name 'snapshot.*'
}

echo "Preparing the test stack..."
docker compose build
docker compose up -d solr
docker compose exec solr wait-for-solr.sh

echo "Verifying that solr has no existing backups..."
if [[ "$(existing_snapshots)" ]]; then
    echo "ERROR: Solr already has backups. Aborting."
    exit 1
fi

docker compose run --rm app
sleep 2

if [[ ! "$(existing_snapshots)" ]]; then
    echo "FAILURE: Solr core was not backed up."
    exit 1
else
    echo "SUCCESS: Solr core was backed up."
    exit 0
fi

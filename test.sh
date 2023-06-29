#!/bin/sh -e

function cleanup {
    echo "Cleaning up..."
    docker compose down -v > /dev/null 2>&1
}
trap cleanup EXIT

function solr_snapshots {
    docker compose exec solr find /var/solr/data -name 'snapshot.*'
}

echo "Preparing the test stack..."
docker compose build > /dev/null 2>&1
docker compose up -d solr > /dev/null 2>&1
docker compose exec solr wait-for-solr.sh > /dev/null 2>&1

echo "Verifying that solr has no existing backups..."
if [ "$(solr_snapshots | wc -l)" -ne "0" ]; then
    echo "ERROR: Solr already has backups. Aborting."
    exit 1
fi

echo "Running the backup container..."
docker compose run --rm app
sleep 2

if [ "$(solr_snapshots | wc -l)" -eq "2" ]; then
    echo "SUCCESS: All Solr cores were backed up."
    exit 0
else
    echo "FAILURE: All Solr cores were not backed up."
    exit 1
fi

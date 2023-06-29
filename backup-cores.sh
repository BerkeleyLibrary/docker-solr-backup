#!/bin/sh -e

if [[ ! "$1" ]]; then
    echo """
Usage: $0 <solr root>

Create backups for all cores in a solr instance.
"""
    exit 1
fi

SOLR_ROOT="${1?:Usage: $0 <solr root>}"

command -v jq >/dev/null 2>&1 || { echo >&2 "jq is required but not installed. Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but not installed. Aborting."; exit 1; }

for core in $(curl -s $SOLR_ROOT/solr/admin/cores?indexInfo=false | jq -r '.status' | jq -r 'keys[]'); do
    echo "Backing up $core"
    curl "${SOLR_ROOT}/solr/${core}/replication?command=backup"
done

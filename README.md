# Backup all cores in a standalone Solr server

A very, very simple script which will backup all cores in a standalone Solr server. It accepts exactly one argument, which is the root URL of the solr server it should connect to (i.e. the portion before "/solr" in the URL).

```sh
docker run --rm ucblib/solr-backup:main http://solr:8983
```

Includes a simple test script which runs against a Docker compose stack with a fresh, empty Solr server.

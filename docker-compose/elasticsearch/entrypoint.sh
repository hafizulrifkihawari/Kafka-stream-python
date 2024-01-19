#!/bin/bash
set -o errexit

# Overrides the default entry point for the Elasticsearch image in order to
# configure Elasticsearch.
if [ ! -f /usr/share/elasticsearch/config/certificates/elasticsearch/elasticsearch.crt ]; then
    elasticsearch-certutil cert --silent --pem --in /config/instances.yml --out certs.zip
    unzip certs.zip -d /usr/share/elasticsearch/config/certificates
    rm certs.zip
fi

# https://github.com/elastic/elasticsearch/blob/master/distribution/docker/src/docker/Dockerfile#L367
exec /usr/local/bin/docker-entrypoint.sh "$@"

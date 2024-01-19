#!/bin/bash

# Healthcheck script for Docker to determine if the service is ready.
# We also use this script to set up passwords.

CACERT_PATH=/usr/share/elasticsearch/config/certificates/ca/ca.crt
ELASTICSEARCH_HOST=https://elasticsearch:9200

curl --cacert "$CACERT_PATH" -s "$ELASTICSEARCH_HOST" >/dev/null
if [ $? = 52 ]; then
    printf "Elasticsearch not ready yet."
else
    response=$(curl --cacert "$CACERT_PATH" --user "elastic:$ELASTIC_PASSWORD" \
        -w "%{http_code}" \
        -s -o /dev/null \
        "$ELASTICSEARCH_HOST/_security/user/glints")
    if [ "$response" = "200" ]; then
        printf "Elasticsearch ready and users created."
        exit
    fi

    response=$(curl --cacert "$CACERT_PATH" -X PUT --user "elastic:$ELASTIC_PASSWORD" \
        -H "Content-Type: application/json" \
        -d "{\"password\":\"$ELASTIC_PASSWORD\", \"roles\": [\"superuser\"]}" \
        -w "%{http_code}" \
        -s -o /dev/null \
        "$ELASTICSEARCH_HOST/_security/user/glints")
    if [ "$response" != "200" ]; then
        printf "Failed to create user \"glints\". HTTP response code: %s" "$response"
        exit 1
    fi

    response=$(curl --cacert "$CACERT_PATH" -X POST --user "elastic:$ELASTIC_PASSWORD" \
        -H "Content-Type: application/json" \
        -d "{\"password\":\"$ELASTIC_PASSWORD\"}" \
        -w "%{http_code}" \
        -s -o /dev/null \
        "$ELASTICSEARCH_HOST/_security/user/kibana_system/_password")
    if [ "$response" != "200" ]; then
        printf "Failed to change password for user \"kibana_system\". HTTP response code: %s" "$response"
        exit 1
    fi
fi

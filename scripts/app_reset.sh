#!/bin/sh

docker-compose exec broker /opt/kafka/bin/kafka-streams-application-reset.sh --application-id $1 --to-earliest --force
docker-compose exec broker /opt/kafka/bin/kafka-consumer-groups.sh --bootstrap-server broker:9092 --reset-offsets --group $1 --all-topics --to-earliest --execute

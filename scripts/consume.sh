#!/bin/sh
read -p "Topic name: "  TOPIC_NAME

docker-compose exec schema-registry /bin/kafka-avro-console-consumer --bootstrap-server broker:9092 --topic $TOPIC_NAME --from-beginning

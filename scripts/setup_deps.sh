#!/bin/sh
MODULE_NAME=$1
INDEX_NAME=$2

docker-compose up -d kafdrop grafana

read -p "Start pg-connect? [Y/n] " answer
if [ "$answer" != "n" ]; then
  docker-compose up -d connect postgres
  CONNECT_SUFFIX=sourceConnector.json
  ./wait-for-endpoint.sh http://localhost:28083/connectors -t 0 -- curl -X DELETE -H "Content-Type: application/json" http://localhost:28083/connectors/$MODULE_NAME
  ./wait-for-endpoint.sh http://localhost:28083/connectors -t 0 -- curl -X POST -H "Content-Type: application/json" --data @../$MODULE_NAME/connectors/$CONNECT_SUFFIX http://localhost:28083/connectors
fi

echo ""

read -p "Start sink-connect? [Y/n] " answer
if [ "$answer" != "n" ]; then
  docker-compose rm --stop -f sink-connect
  docker compose exec broker /opt/kafka/bin/kafka-consumer-groups.sh --bootstrap-server broker:9092 --reset-offsets --group connect-$MODULE_NAME --topic $INDEX_NAME --to-earliest --execute

  CONNECT_SUFFIX=sinkConnector.json
  docker-compose up -d sink-connect
  
  ./wait-for-endpoint.sh http://localhost:28084/connectors -t 0 -- curl -X DELETE -H "Content-Type: application/json" http://localhost:28084/connectors/$MODULE_NAME
  ./wait-for-endpoint.sh http://localhost:28084/connectors -t 0 -- curl -X POST -H "Content-Type: application/json" --data @../$MODULE_NAME/connectors/$CONNECT_SUFFIX http://localhost:28084/connectors
fi

#!/bin/bash
echo "Launching Kafka Connect worker"
/docker-entrypoint.sh start &
echo "Waiting for Source Connect to start listening on localhost ⏳"
while : ; do
  curl_status=$(curl -s -o /dev/null -w %{http_code} http://connect:8083/connectors)
  echo -e $(date) " Kafka Connect listener HTTP state: " $curl_status " (waiting for 200)"
  if [ $curl_status -eq 200 ] ; then
    break
  fi
  sleep 2 
done
curl -X POST -H "Content-Type: application/json" --data @connect.json http://connect:8083/connectors
sleep infinity


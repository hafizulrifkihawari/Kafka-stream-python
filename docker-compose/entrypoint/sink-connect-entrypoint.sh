#!/bin/bash
echo "Installing Connector"
wget https://github.com/glints-dev/kafka-connect-elasticsearch/releases/download/version-ignore/confluentinc-kafka-connect-elasticsearch-12.1.0-SNAPSHOT.tar.gz
tar -xvzf confluentinc-kafka-connect-elasticsearch-12.1.0-SNAPSHOT.tar.gz -C /usr/share/confluent-hub-components
exec /etc/confluent/docker/run

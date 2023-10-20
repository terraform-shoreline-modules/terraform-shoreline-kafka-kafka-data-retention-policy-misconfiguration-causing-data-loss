

#!/bin/bash



# Set variables

KAFKA_CONFIG_FILE=${PATH_TO_KAFKA_CONFIG_FILE}

DATA_RETENTION_POLICY=${DESIRED_DATA_RETENTION_POLICY}



# Stop Kafka server

sudo systemctl stop kafka



# Update retention policy in Kafka config file

sudo sed -i "s/^log.retention.hours=.*/log.retention.hours=$DATA_RETENTION_POLICY/" $KAFKA_CONFIG_FILE



# Start Kafka server

sudo systemctl start kafka



# Verify retention policy update

echo "Current data retention policy:"

grep log.retention.hours $KAFKA_CONFIG_FILE
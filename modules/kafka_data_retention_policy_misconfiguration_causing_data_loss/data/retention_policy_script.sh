bash

#!/bin/bash



# Define variables

KAFKA_CONFIG_FILE=${PATH_TO_KAFKA_CONFIGURATION_FILE}

CORRECT_RETENTION_POLICY=${CORRECT_RETENTION_POLICY}



# Check current retention policy

CURRENT_RETENTION_POLICY=$(grep -P "^log\.retention\.hours" $KAFKA_CONFIG_FILE | awk -F "=" '{print $2}')



if [ "$CURRENT_RETENTION_POLICY" != "$CORRECT_RETENTION_POLICY" ]; then

    # Set correct retention policy

    sed -i "s/^log\.retention\.hours=.*/log.retention.hours=$CORRECT_RETENTION_POLICY/" $KAFKA_CONFIG_FILE



    # Restart Kafka broker

    systemctl restart kafka

fi
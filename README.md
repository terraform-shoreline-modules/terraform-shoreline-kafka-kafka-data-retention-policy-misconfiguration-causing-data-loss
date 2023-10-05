
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Data Retention Policy Misconfiguration Causing Data Loss.
---

This incident type occurs when there is a misconfiguration in the kafka data retention policy. Kafka is a distributed streaming platform that is designed to handle high volume data streams. It has a feature that allows the user to set a retention policy, which determines how long to keep the data in the kafka cluster. If the retention policy is misconfigured, it can lead to data loss, meaning that some data is deleted from the kafka cluster before the intended expiration date. This incident can have serious consequences on the applications that depend on the kafka cluster for processing and analyzing the data.

### Parameters
```shell
export PATH_TO_KAFKA_CONFIGURATION_FILE="PLACEHOLDER"

export PATH_TO_KAFKA_DATA_RETENTION_POLICY_FILE="PLACEHOLDER"

export KAFKA_LOG_PATH="PLACEHOLDER"

export KAFKA_NODE="PLACEHOLDER"

export DATA_VOLUME_IN_BYTES="PLACEHOLDER"

export RETENTION_PERIOD_DAYS="PLACEHOLDER"

export CORRECT_RETENTION_POLICY="PLACEHOLDER"
```

## Debug

### Step 2: Check Kafka configuration
```shell
cat ${PATH_TO_KAFKA_CONFIGURATION_FILE}
```

### Step 1: Check if Kafka is running
```shell
systemctl status kafka
```

### Step 3: Check Kafka data retention policy
```shell
cat ${PATH_TO_KAFKA_DATA_RETENTION_POLICY_FILE}
```

### Step 4: Check Kafka logs for data loss errors
```shell
grep "data loss" ${KAFKA_LOG_PATH}
```

### The retention period was set too high, causing the Kafka disks to fill up and overwrite the oldest data.
```shell
bash

#!/bin/bash



# 1. Check the disk space usage on the Kafka nodes

df -h ${KAFKA_NODE}



# 2. Check the Kafka logs for disk usage warnings or errors

grep -i "disk" ${KAFKA_LOG_PATH}



# 3. Check the Kafka broker configuration for retention period settings

cat ${PATH_TO_KAFKA_CONFIGURATION_FILE} | grep "retention"



# 4. Calculate the expected disk usage based on the retention period and data volume

expected_disk_usage=$(${DATA_VOLUME_IN_BYTES} * ${RETENTION_PERIOD_DAYS})



# 5. Compare the expected usage to the actual usage

if [ "$expected_disk_usage" -lt "$actual_disk_usage" ]; then

    echo "Disk usage is too high. Please adjust the retention period or allocate more disk space."

else

    echo "Disk usage is within expected range."

fi


```

## Repair

### Check the current Kafka data retention policy and ensure it is set correctly.
```shell
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


```
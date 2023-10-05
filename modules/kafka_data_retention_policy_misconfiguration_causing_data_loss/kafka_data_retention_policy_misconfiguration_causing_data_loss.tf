resource "shoreline_notebook" "kafka_data_retention_policy_misconfiguration_causing_data_loss" {
  name       = "kafka_data_retention_policy_misconfiguration_causing_data_loss"
  data       = file("${path.module}/data/kafka_data_retention_policy_misconfiguration_causing_data_loss.json")
  depends_on = [shoreline_action.invoke_disk_check,shoreline_action.invoke_retention_policy_script]
}

resource "shoreline_file" "disk_check" {
  name             = "disk_check"
  input_file       = "${path.module}/data/disk_check.sh"
  md5              = filemd5("${path.module}/data/disk_check.sh")
  description      = "The retention period was set too high, causing the Kafka disks to fill up and overwrite the oldest data."
  destination_path = "/agent/scripts/disk_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "retention_policy_script" {
  name             = "retention_policy_script"
  input_file       = "${path.module}/data/retention_policy_script.sh"
  md5              = filemd5("${path.module}/data/retention_policy_script.sh")
  description      = "Check the current Kafka data retention policy and ensure it is set correctly."
  destination_path = "/agent/scripts/retention_policy_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_disk_check" {
  name        = "invoke_disk_check"
  description = "The retention period was set too high, causing the Kafka disks to fill up and overwrite the oldest data."
  command     = "`chmod +x /agent/scripts/disk_check.sh && /agent/scripts/disk_check.sh`"
  params      = ["RETENTION_PERIOD_DAYS","DATA_VOLUME_IN_BYTES","PATH_TO_KAFKA_CONFIGURATION_FILE","KAFKA_NODE","KAFKA_LOG_PATH"]
  file_deps   = ["disk_check"]
  enabled     = true
  depends_on  = [shoreline_file.disk_check]
}

resource "shoreline_action" "invoke_retention_policy_script" {
  name        = "invoke_retention_policy_script"
  description = "Check the current Kafka data retention policy and ensure it is set correctly."
  command     = "`chmod +x /agent/scripts/retention_policy_script.sh && /agent/scripts/retention_policy_script.sh`"
  params      = ["PATH_TO_KAFKA_CONFIGURATION_FILE","CORRECT_RETENTION_POLICY"]
  file_deps   = ["retention_policy_script"]
  enabled     = true
  depends_on  = [shoreline_file.retention_policy_script]
}


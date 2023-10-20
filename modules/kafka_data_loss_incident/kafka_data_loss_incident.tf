resource "shoreline_notebook" "kafka_data_loss_incident" {
  name       = "kafka_data_loss_incident"
  data       = file("${path.module}/data/kafka_data_loss_incident.json")
  depends_on = [shoreline_action.invoke_update_retention_policy]
}

resource "shoreline_file" "update_retention_policy" {
  name             = "update_retention_policy"
  input_file       = "${path.module}/data/update_retention_policy.sh"
  md5              = filemd5("${path.module}/data/update_retention_policy.sh")
  description      = "Review and update Kafka's data retention policy to ensure that it is correctly configured and aligned with your data retention requirements."
  destination_path = "/tmp/update_retention_policy.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_retention_policy" {
  name        = "invoke_update_retention_policy"
  description = "Review and update Kafka's data retention policy to ensure that it is correctly configured and aligned with your data retention requirements."
  command     = "`chmod +x /tmp/update_retention_policy.sh && /tmp/update_retention_policy.sh`"
  params      = ["PATH_TO_KAFKA_CONFIG_FILE","DESIRED_DATA_RETENTION_POLICY"]
  file_deps   = ["update_retention_policy"]
  enabled     = true
  depends_on  = [shoreline_file.update_retention_policy]
}


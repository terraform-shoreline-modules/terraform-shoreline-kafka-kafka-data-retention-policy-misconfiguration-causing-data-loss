terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_data_retention_policy_misconfiguration_causing_data_loss" {
  source    = "./modules/kafka_data_retention_policy_misconfiguration_causing_data_loss"

  providers = {
    shoreline = shoreline
  }
}
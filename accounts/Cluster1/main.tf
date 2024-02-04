
data "terraform_remote_state" "confluent_environment" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_service_account.app-manager" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_api_key.app-manager-kafka-api-key" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_kafka_cluster.dedicated" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}


module "confluent_kafka_topics" {
  source = "../../modules/confluent_kafka_topics_module"

  kafka_id              = data.terraform_remote_state.confluent_kafka_cluster.dedicated.outputs.id
  kafka_rest_endpoint   = data.terraform_remote_state.confluent_kafka_cluster.dedicated.outputs.rest_endpoint
  kafka_api_key         = data.terraform_remote_state.confluent_api_key.app-manager-kafka-api-key.outputs.id
  kafka_api_secret      = data.terraform_remote_state.confluent_api_key.app-manager-kafka-api-key.outputs.secret
  cloud_api_key         = var.confluent_cloud_api_key
  cloud_api_secret      = var.confluent_cloud_api_secret
  environment_id        = data.terraform_remote_state.confluent_environment.staging.outputs.id
  kafka_api_version     = data.terraform_remote_state.confluent_kafka_cluster.dedicated.outputs.api_version
  kafka_kind            = data.terraform_remote_state.confluent_kafka_cluster.dedicated.outputs.kind
  confluent_service_account_id          = data.terraform_remote_state.confluent_service_account.app-manager.outputs.id
  confluent_service_account_api_version = data.terraform_remote_state.confluent_service_account.app-manager.outputs.api_version
  confluent_service_account_kind        = data.terraform_remote_state.confluent_service_account.app-manager.outputs.kind
  topics                = jsondecode(file("topics.json"))

}

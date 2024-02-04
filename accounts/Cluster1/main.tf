
data "terraform_remote_state" "confluent_environment" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_service_account" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_api_key" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "kafka_2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_kafka_cluster" {
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

  kafka_id              = data.terraform_remote_state.confluent_kafka_cluster.outputs.id
  kafka_rest_endpoint   = data.terraform_remote_state.confluent_kafka_cluster.outputs.rest_endpoint
  kafka_api_key         = data.terraform_remote_state.confluent_api_key.outputs.id
  kafka_api_secret      = data.terraform_remote_state.confluent_api_key.outputs.secret
  cloud_api_key         = var.confluent_cloud_api_key
  cloud_api_secret      = var.confluent_cloud_api_secret
  environment_id        = data.terraform_remote_state.confluent_environment.outputs.id
  kafka_api_version     = data.terraform_remote_state.confluent_kafka_cluster.outputs.api_version
  kafka_kind            = data.terraform_remote_state.confluent_kafka_cluster.outputs.kind
  confluent_service_account_id          = data.terraform_remote_state.confluent_service_account.app-manager.outputs.id
  confluent_service_account_api_version = data.terraform_remote_state.confluent_service_account.app-manager.outputs.api_version
  confluent_service_account_kind        = data.terraform_remote_state.confluent_service_account.app-manager.outputs.kind
  topics                = jsondecode(file("topics.json"))

}

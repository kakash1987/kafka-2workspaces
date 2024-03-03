
data "terraform_remote_state" "confluent_environment" {
  backend = "remote"
  config = {
    organization = "KakashDOOEL"
    workspaces = {
      name = "kafka-2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_service_account" {
  backend = "remote"
  config = {
    organization = "KakashDOOEL"
    workspaces = {
      name = "kafka-2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_api_key" {
  backend = "remote"
  config = {
    organization = "KakashDOOEL"
    workspaces = {
      name = "kafka-2workspaces"
    }
  }
}

data "terraform_remote_state" "confluent_kafka_cluster" {
  backend = "remote"
  config = {
    organization = "KakashDOOEL"
    workspaces = {
      name = "kafka-2workspaces"
    }
  }
}


module "confluent_kafka_topics" {
  source = "../../modules/confluent_kafka_topics_module"

  kafka_id              = data.terraform_remote_state.confluent_kafka_cluster.outputs.confluent_kafka_cluster_id
  kafka_rest_endpoint   = data.terraform_remote_state.confluent_kafka_cluster.outputs.confluent_kafka_cluster_rest_endpoint
  kafka_api_key         = data.terraform_remote_state.confluent_api_key.outputs.confluent_api_key_id
  kafka_api_secret      = data.terraform_remote_state.confluent_api_key.outputs.confluent_api_key_secret
  #cloud_api_key         = var.confluent_cloud_api_key
  #cloud_api_secret      = var.confluent_cloud_api_secret
  environment_id        = data.terraform_remote_state.confluent_environment.outputs.confluent_environment_id
  kafka_api_version     = data.terraform_remote_state.confluent_kafka_cluster.outputs.confluent_kafka_cluster_api_version
  kafka_kind            = data.terraform_remote_state.confluent_kafka_cluster.outputs.confluent_kafka_cluster_kind
  confluent_service_account_id          = data.terraform_remote_state.confluent_service_account.outputs.confluent_service_account_app-manager_id
  confluent_service_account_api_version = data.terraform_remote_state.confluent_service_account.outputs.confluent_service_account_app-manager_api_version
  confluent_service_account_kind        = data.terraform_remote_state.confluent_service_account.outputs.confluent_service_account_app-manager_kind
  topics                = jsondecode(file("topics.json"))

output "topic_name" {
  value = {
    for k, v in confluent_kafka_topic.main : k => v.topic_name
  }
}

}



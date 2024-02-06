resource "confluent_service_account" "app-manager" {
  display_name = "app-manager"
  description  = "Service account to manage 'inventory' Kafka cluster"
}

output "confluent_service_account_app-manager_id" {
  value = confluent_service_account.app-manager.id
}
output "confluent_service_account_app-manager_api_version" {
  value = confluent_service_account.app-manager.api_version
}
output "confluent_service_account_app-manager_kind" {
  value = confluent_service_account.app-manager.kind
}





resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.dedicated.rbac_crn
depends_on = [
    confluent_kafka_cluster.dedicated,
    confluent_service_account.app-manager
  ]
}




resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  disable_wait_for_ready = "true"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dedicated.id
    api_version = confluent_kafka_cluster.dedicated.api_version
    kind        = confluent_kafka_cluster.dedicated.kind

    environment {
      id = confluent_environment.staging.id
    }
  }
  depends_on = [
    confluent_kafka_cluster.dedicated,
    confluent_environment.staging,
    confluent_service_account.app-manager  
  ]
}

output "confluent_api_key_id" {
  value = confluent_api_key.app-manager-kafka-api-key.id
}

output "confluent_api_key_secret" {
  value = confluent_api_key.app-manager-kafka-api-key.secret
  sensitive = true
}

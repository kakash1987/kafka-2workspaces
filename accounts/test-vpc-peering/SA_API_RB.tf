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



resource "confluent_service_account" "app-manager2" {
  display_name = "app-manager2"
  description  = "Service account to manage 'inventory2' Kafka cluster"
}

output "confluent_service_account_app-manager2_id" {
  value = confluent_service_account.app-manager2.id
}
output "confluent_service_account_app-manager2_api_version" {
  value = confluent_service_account.app-manager2.api_version
}
output "confluent_service_account_app-manager2_kind" {
  value = confluent_service_account.app-manager2.kind
}

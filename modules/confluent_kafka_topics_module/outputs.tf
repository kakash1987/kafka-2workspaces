#output "kafka_topics" {
#  description = "Map of created Confluent Kafka topics"
#  value       = confluent_kafka_topic.main
#}

#output "service_accounts_consumers" {
#  description = "Map of created SA for consumers"
#  value       = values(confluent_service_account.app-consumer).*.id
#}

#output "confluent_api_key" {
#  description = "Map of created API keys for consumers"
#  value       = confluent_api_key.app-producer-kafka-api-key.id
#}



output "target-groups-arn-alternatice" {
  value = {for k, v in confluent_service_account.app-consumer: k => v.id}
}



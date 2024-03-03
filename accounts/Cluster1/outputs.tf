#output "created_kafka_topics" {
#  description = "Map of created Confluent Kafka topics"
#  value       = module.confluent_kafka_topics.kafka_topics
#  sensitive = true
#}

output "created_service_accounts_consumers" {
  description = "Map of created SA for consumers"
  value       = module.confluent_kafka_topics.service_accounts_consumers.*.id
}

#output "created_confluent_api_key" {
#  description = "Map of created API keys for consumers"
#  value       = module.confluent_kafka_topics.confluent_api_key.id
#}




output "created_kafka_topics" {
  description = "Map of created Confluent Kafka topics"
  value       = nonsensitive(module.confluent_kafka_topics.kafka_topics)
}


output "kafka_topics" {
  description = "Map of created Confluent Kafka topics"
  value       = nonsensitive(confluent_kafka_topic.main)
}

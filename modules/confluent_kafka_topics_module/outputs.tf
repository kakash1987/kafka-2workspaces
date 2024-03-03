output "resource-ids" {
  value = <<-EOT

Kafka topic name: ${var.topic_name}

  Kafka API Key to consume the data from the '${var.topic_name}' topic:
  Kafka API Key:     "${module.confluent_kafka_topics_module.consumer_kafka_api_key_id}"
  Kafka API Secret:  "${module.confluent_kafka_topics_module.consumer_kafka_api_key_secret}"

  Kafka API Key to produce the data to the '${var.topic_name}' topic:
  Kafka API Key:     "${module.confluent_kafka_topics_module.producer_kafka_api_key_id}"
  Kafka API Secret:  "${module.confluent_kafka_topics_module.producer_kafka_api_key_secret}"

EOT

  sensitive = true
}

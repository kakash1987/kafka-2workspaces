terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.56.0"
    }
  }
}


resource "confluent_kafka_topic" "main" {
  for_each = var.topics
  kafka_cluster {
    id = var.kafka_id
  }
  topic_name       = each.key
  partitions_count = each.value.partitions_count
  config           = each.value.config
  rest_endpoint    = var.kafka_rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }

  lifecycle {
    prevent_destroy = false
  }

}

#output "topic_name" {
#  value = {
#    for k, v in confluent_kafka_topic.main : k => v.topic_name
#  }
#}

#output "bd_name" {
#  value = values(confluent_kafka_topic.main)[*].topic_name
#}

#output "topic_name" {
#value = [
#for key, value in confluent_kafka_topic.main : value.topic_name
#]
#}

#output "first_topic_name" {
#  value = confluent_kafka_topic.main.topic_name[0]
#}

#output "second_topic_name" {
#  value = confluent_kafka_topic.main.topic_name[1]
#}





resource "confluent_service_account" "app-consumer" {
  for_each = var.topics
  display_name = each.value.consumer
  description  = "Service account to consume from '${each.key}' topic of 'inventory' Kafka cluster"
}


resource "confluent_api_key" "app-consumer-kafka-api-key" {
  for_each = var.topics
  display_name = each.value.consumer
  description  = "Kafka API Key that is owned by 'app-consumer' service account"
  disable_wait_for_ready = "true"
  owner {
    id          = confluent_service_account.app-consumer[each.key].id
    api_version = confluent_service_account.app-consumer[each.key].api_version
    kind        = confluent_service_account.app-consumer[each.key].kind
  }

  managed_resource {
    id          = var.kafka_id
    api_version = var.kafka_api_version
    kind        = var.kafka_kind

    environment {
      id = var.environment_id
    }
  }
}

resource "confluent_service_account" "app-producer" {
  for_each = var.topics
  display_name = each.value.producer
  description  = "Service account to produce to '${each.key}' topic of 'inventory' Kafka cluster"
}

resource "confluent_api_key" "app-producer-kafka-api-key" {
  for_each = var.topics
  display_name = each.value.producer
  description  = "Kafka API Key that is owned by 'app-producer' service account"
  disable_wait_for_ready = "true"
  owner {
    id          = confluent_service_account.app-producer[each.key].id
    api_version = confluent_service_account.app-producer[each.key].api_version
    kind        = confluent_service_account.app-producer[each.key].kind
  }

  managed_resource {
    id          = var.kafka_id
    api_version = var.kafka_api_version
    kind        = var.kafka_kind

    environment {
      id = var.environment_id
    }
  }
}

resource "confluent_kafka_acl" "produce" {
  for_each = var.topics

  kafka_cluster {
    id = var.kafka_id
  }
  resource_type = "TOPIC"
  resource_name = each.key
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app-producer[each.key].id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.kafka_rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}

resource "confluent_kafka_acl" "consume" {
  for_each = var.topics

  kafka_cluster {
    id = var.kafka_id
  }
  resource_type = "TOPIC"
  resource_name = each.key
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app-consumer[each.key].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.kafka_rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}

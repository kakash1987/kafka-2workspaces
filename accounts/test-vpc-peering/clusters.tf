resource "confluent_kafka_cluster" "dedicated" {
  display_name = "inventory"
  availability = "SINGLE_ZONE"
  cloud        = confluent_network.peering.cloud
  region       = confluent_network.peering.region
  dedicated {
    cku = 1
  }
  environment {
    id = confluent_environment.staging.id
  }
  network {
    id = confluent_network.peering.id
  }

}

output "confluent_kafka_cluster_id" {
  value = confluent_kafka_cluster.dedicated.id
}
output "confluent_kafka_cluster_rest_endpoint" {
  value = confluent_kafka_cluster.dedicated.rest_endpoint
}
output "confluent_kafka_cluster_api_version" {
  value = confluent_kafka_cluster.dedicated.api_version
}
output "confluent_kafka_cluster_kind" {
  value = confluent_kafka_cluster.dedicated.kind
}




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

resource "confluent_kafka_cluster" "dedicated2" {
  display_name = "inventory2"
  availability = "SINGLE_ZONE"
  cloud        = confluent_network.peering2.cloud
  region       = confluent_network.peering2.region
  dedicated {
    cku = 1
  }
  environment {
    id = confluent_environment.test.id
  }
  network {
    id = confluent_network.peering3.id
  }
depends_on = [
    confluent_environment.test,
    confluent_network.peering3  
  ]
}

output "confluent_kafka_cluster_dedicated2_id" {
  value = confluent_kafka_cluster.dedicated2.id
}
output "confluent_kafka_cluster_dedicated2_rest_endpoint" {
  value = confluent_kafka_cluster.dedicated2.rest_endpoint
}
output "confluent_kafka_cluster_dedicated2_api_version" {
  value = confluent_kafka_cluster.dedicated2.api_version
}
output "confluent_kafka_cluster_dedicated2_kind" {
  value = confluent_kafka_cluster.dedicated2.kind
}




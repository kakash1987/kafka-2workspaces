module "confluent_kafka_topics" {
  source = "../../modules/confluent_kafka_topics_module"

  # kafka_id            = var.kafka_id
  # kafka_rest_endpoint = var.kafka_rest_endpoint
  # kafka_api_key       = var.kafka_api_key
  # kafka_api_secret    = var.kafka_api_secret
  kafka_id              = confluent_kafka_cluster.dedicated.id
  kafka_rest_endpoint   = confluent_kafka_cluster.dedicated.rest_endpoint
  kafka_api_key         = confluent_api_key.app-manager-kafka-api-key.id
  kafka_api_secret      = confluent_api_key.app-manager-kafka-api-key.secret
  cloud_api_key         = var.confluent_cloud_api_key
  cloud_api_secret      = var.confluent_cloud_api_secret
  environment_id        = confluent_environment.staging.id
  kafka_api_version     = confluent_kafka_cluster.dedicated.api_version
  kafka_kind            = confluent_kafka_cluster.dedicated.kind
  confluent_service_account_id          = confluent_service_account.app-manager.id
  confluent_service_account_api_version = confluent_service_account.app-manager.api_version
  confluent_service_account_kind        = confluent_service_account.app-manager.kind
  topics                = jsondecode(file("topics.json"))

  depends_on = [
    confluent_kafka_cluster.dedicated,
    confluent_environment.staging,
    confluent_service_account.app-manager,
    confluent_api_key.app-manager-kafka-api-key,
    confluent_network.peering,
    confluent_peering.aws,
    confluent_role_binding.app-manager-kafka-cluster-admin,
    aws_vpc_peering_connection_accepter.peer,
    aws_route.r  
  ]
  
}

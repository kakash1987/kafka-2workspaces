resource "confluent_environment" "staging" {
  display_name = "Staging"
}

output "confluent_environment_id" {
  value = confluent_environment.staging.id
}



// 'app-manager' service account is required in this configuration to create 'orders' topic and grant ACLs
// to 'app-producer' and 'app-consumer' service accounts.
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


resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.dedicated.rbac_crn
depends_on = [
    confluent_kafka_cluster.dedicated,
    confluent_service_account.app-manager
  ]
}


resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  disable_wait_for_ready = "true"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dedicated.id
    api_version = confluent_kafka_cluster.dedicated.api_version
    kind        = confluent_kafka_cluster.dedicated.kind

    environment {
      id = confluent_environment.staging.id
    }
  }
  depends_on = [
    confluent_kafka_cluster.dedicated,
    confluent_environment.staging,
    confluent_service_account.app-manager  
  ]
}

output "confluent_api_key_id" {
  value = confluent_api_key.app-manager-kafka-api-key.id
}

output "confluent_api_key_secret" {
  value = confluent_api_key.app-manager-kafka-api-key.secret
  sensitive = true
}


  # The goal is to ensure that confluent_role_binding.app-manager-kafka-cluster-admin is created before
  # confluent_api_key.app-manager-kafka-api-key is used to create instances of
  # confluent_kafka_topic, confluent_kafka_acl resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.app-manager-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic, confluent_kafka_acl resources instead.




resource "confluent_network" "peering" {
  display_name     = "Peering Network"
  cloud            = "AWS"
  region           = var.region
  cidr             = var.cidr
  connection_types = ["PEERING"]
  environment {
    id = confluent_environment.staging.id
  }
depends_on = [
    confluent_environment.staging  
  ]
}



resource "confluent_peering" "aws" {
  display_name = "AWS Peering"
  aws {
    account         = var.aws_account_id
    vpc             = var.vpc_id
    routes          = var.routes
    customer_region = var.customer_region
  }
  environment {
    id = confluent_environment.staging.id
  }
  network {
    id = confluent_network.peering.id
  }
depends_on = [
    confluent_environment.staging,
    confluent_network.peering
  ]
}



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
  depends_on = [
    confluent_environment.staging,
    confluent_network.peering  
  ]
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



# https://docs.confluent.io/cloud/current/networking/peering/aws-peering.html
# Create a VPC Peering Connection to Confluent Cloud on AWS

provider "aws" {
  region = var.customer_region
}

# Accepter's side of the connection.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection

data "aws_vpc_peering_connection" "accepter" {
  vpc_id      = confluent_network.peering.aws[0].vpc
  peer_vpc_id = confluent_peering.aws.aws[0].vpc
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
  auto_accept               = true
}

# Find the routing table
data "aws_route_tables" "rts" {
  vpc_id = var.vpc_id
}

resource "aws_route" "r" {
  for_each                  = toset(data.aws_route_tables.rts.ids)
  route_table_id            = each.key
  destination_cidr_block    = confluent_network.peering.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
}


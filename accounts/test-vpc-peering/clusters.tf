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

resource "confluent_kafka_cluster" "dedicated2" {
  display_name = "inventory2"
  availability = "SINGLE_ZONE"
  cloud        = confluent_network.peering.cloud
  region       = confluent_network.peering.region
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
    #confluent_network.peering3  
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


resource "confluent_network" "peering3" {
  display_name     = "Peering Network"
  cloud            = "AWS"
  region           = var.region
  cidr             = var.cidr2
  connection_types = ["PEERING"]
  environment {
    id = confluent_environment.test.id
  }
depends_on = [
    confluent_environment.test  
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

resource "confluent_peering" "aws3" {
  display_name = "AWS Peering 3"
  aws {
    account         = var.aws_account_id
    vpc             = var.vpc_id
    routes          = var.routes
    customer_region = var.customer_region
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

data "aws_vpc_peering_connection" "accepter3" {
  vpc_id      = confluent_network.peering3.aws[0].vpc
  peer_vpc_id = confluent_peering.aws3.aws[0].vpc
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_accepter" "peer3" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter3.id
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

resource "aws_route" "r3" {
  for_each                  = toset(data.aws_route_tables.rts.ids)
  route_table_id            = each.key
  destination_cidr_block    = confluent_network.peering3.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter3.id
}

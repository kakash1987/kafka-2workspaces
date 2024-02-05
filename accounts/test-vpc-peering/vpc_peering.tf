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
  region           = var.region2
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
    vpc             = var.vpc2_id
    routes          = var.routes2
    customer_region = var.customer_region2
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
  alias = "region1"
  region = var.customer_region
}

provider "aws" {
  alias = "region2"
  region = var.customer_region2
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

data "aws_route_tables" "rts2" {
  vpc_id = var.vpc2_id
}

resource "aws_route" "r" {
  for_each                  = toset(data.aws_route_tables.rts.ids)
  route_table_id            = each.key
  destination_cidr_block    = confluent_network.peering.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
}

resource "aws_route" "r3" {
  for_each                  = toset(data.aws_route_tables.rts2.ids)
  route_table_id            = each.key
  destination_cidr_block    = confluent_network.peering3.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter3.id
}


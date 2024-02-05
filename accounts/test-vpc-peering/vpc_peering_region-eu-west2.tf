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

provider "aws" {
  region = "us-east-2" "eu-west-2"
}

data "aws_vpc_peering_connection" "accepter3" {
  vpc_id      = confluent_network.peering3.aws[0].vpc
  peer_vpc_id = confluent_peering.aws3.aws[0].vpc
}

resource "aws_vpc_peering_connection_accepter" "peer3" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter3.id
  auto_accept               = true
}

data "aws_route_tables" "rts2" {
  vpc_id = var.vpc2_id
}

resource "aws_route" "r3" {
  for_each                  = toset(data.aws_route_tables.rts2.ids)
  route_table_id            = each.key
  destination_cidr_block    = confluent_network.peering3.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter3.id
}







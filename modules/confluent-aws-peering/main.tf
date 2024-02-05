resource "confluent_peering" "aws" {
  display_name = "$(var.vpc_id)"
  aws {
    account         = var.aws_account_id
    vpc             = var.vpc_id
    routes          = var.routes
    customer_region = var.customer_region
  }
  environment {
    id = var.confluent_environment_id
    #id = confluent_environment.staging.id
  }
  network {
    id = var.confluent_network_peering_id
    #id = confluent_network.peering.id
  }
  depends_on = [
    var.confluent_environment_id,
    var.confluent_network_peering_id
    #confluent_environment.staging,
    #confluent_network.peering
  ]
}

provider "aws" {
  region = var.customer_region
}

data "aws_vpc_peering_connection" "accepter" {
  vpc_id      = var.confluent_network_peering_vpc
  #vpc_id      = confluent_network.peering.aws[0].vpc
  peer_vpc_id = confluent_peering.aws.aws[0].vpc
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
  auto_accept               = true
}

data "aws_route_tables" "rts" {
  vpc_id = var.vpc_id
}

resource "aws_route" "r" {
  for_each  = toset(data.aws_route_tables.rts.ids)

  route_table_id            = each.key
  destination_cidr_block    = var.confluent_network_peering_cidr
  #destination_cidr_block    = confluent_network.peering.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
}

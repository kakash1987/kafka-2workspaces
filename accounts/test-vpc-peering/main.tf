
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


provider "aws" {
  region = var.customer_region
}


module "peering_uk_app" {
  source = "../../modules/confluent-aws-peering"

  aws_account_id                     = var.aws_account_id
  customer_region                    = var.customer_region
  region                             = var.region
  vpc_id                             = var.vpc_id
  routes                             = var.routes
  confluent_environment_id           = confluent_environment.staging.id
  confluent_network_peering_id   = confluent_network.peering.id
  confluent_network_peering_vpc  = confluent_network.peering.aws[0].vpc
  confluent_network_peering_cidr = confluent_network.peering.cidr
}


module "peering_uk_app2" {
  source = "../../modules/confluent-aws-peering"

  aws_account_id                     = var.aws_account_id
  customer_region                    = var.customer_region2
  region                             = var.region2
  vpc_id                             = var.vpc2_id
  routes                             = var.routes2
  confluent_environment_id           = confluent_environment.test.id
  confluent_network_peering_id   = confluent_network.peering3.id
  confluent_network_peering_vpc  = confluent_network.peering3.aws[0].vpc
  confluent_network_peering_cidr = confluent_network.peering3.cidr
}


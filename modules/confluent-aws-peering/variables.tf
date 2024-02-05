variable "region" {
  description = "AWS region where resources need to be created"
  type    = string
}

variable "vpc_id" {
  description = "The AWS VPC ID of the peer VPC that you're peering with Confluent Cloud."
  type        = string
}

variable "routes" {
  description = "The AWS VPC CIDR blocks or subsets. This must be from the supported CIDR blocks and must not overlap with your Confluent Cloud CIDR block or any other network peering connection VPC CIDR."
  type        = list(string)
}

variable "confluent_environment_id" {
  type = string
}

variable "confluent_network_aws_peering_id" {
  type = string
}

variable "confluent_network_aws_peering_vpc" {
  type = string
}

variable "confluent_network_aws_peering_cidr" {
  type = string
}

variable "customer_region" {
  description = "The region of the AWS peer VPC."
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID of the peer VPC owner (12 digits)."
  type        = string
}

variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
  default = ""
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
  default = ""
}

variable "kafka_api_key" {
  description = "Kafka API Key that is owned by service account that has permissions to create topics (e.g., has at least CloudClusterAdmin role)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "kafka_api_secret" {
  description = "Kafka API Secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "kafka_rest_endpoint" {
  description = "The REST Endpoint of the Kafka cluster"
  type        = string
  default     = ""
}

variable "kafka_id" {
  description = "The ID the the Kafka cluster of the form 'lkc-'"
  type        = string
  default     = ""
}

variable "topics" {
  description = "A map of Kafka topic configurations"
  type        = map(object({ config : map(string), partitions_count : number, producer : string, consumer : string, }))
  default     = {}
}

variable "region" {
  description = "The region of Confluent Cloud Network."
  type        = string
  default     = "us-east-2"
}

#variable "region2" {
#  description = "The region of Confluent Cloud Network."
#  type        = string
#  default     = "eu-west-2"
#}

variable "cidr" {
  description = "The CIDR of Confluent Cloud Network."
  type        = string
  default     = "10.1.0.0/16"
}

#variable "cidr2" {
#  description = "The CIDR of Confluent Cloud Network."
#  type        = string
#  default     = "10.2.0.0/16"
#}

variable "aws_account_id" {
  description = "The AWS Account ID of the peer VPC owner (12 digits)."
  type        = string
  default     = "221896574556"
}

variable "vpc_id" {
  description = "The AWS VPC ID of the peer VPC that you're peering with Confluent Cloud."
  type        = string
  default     = "vpc-069a48166920054b7"
}

#variable "vpc2_id" {
#  description = "The AWS VPC ID of the peer VPC that you're peering with Confluent Cloud."
#  type        = string
#  default     = "vpc-069cd0f063ca2d3e4"
#}

variable "routes" {
  description = "The AWS VPC CIDR blocks or subsets. This must be from the supported CIDR blocks and must not overlap with your Confluent Cloud CIDR block or any other network peering connection VPC CIDR."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

#variable "routes2" {
#  description = "The AWS VPC CIDR blocks or subsets. This must be from the supported CIDR blocks and must not overlap with your Confluent Cloud CIDR block or any other network peering connection VPC CIDR."
#  type        = list(string)
#  default     = ["10.6.0.0/16"]
#}

variable "customer_region" {
  description = "The region of the AWS peer VPC."
  type        = string
  default     = "us-east-2"
}

#variable "customer_region2" {
#  description = "The region of the AWS peer VPC."
#  type        = string
#  default     = "eu-west-2"
#}

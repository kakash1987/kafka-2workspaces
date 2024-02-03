variable "cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
  default = "PRDI5NKO3K2XGAJJ"
}

variable "cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
  default = "4Dtmgmat7Dw98AI0wK7Sz6WRYDTLevQY8HKxPokZknCtN6pu+tRnbRm8rZezy4rQ"
}


variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
  default = "PRDI5NKO3K2XGAJJ"
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
  default = "4Dtmgmat7Dw98AI0wK7Sz6WRYDTLevQY8HKxPokZknCtN6pu+tRnbRm8rZezy4rQ"
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




variable "environment_id" {
    type = string
    default = ""
}
  

variable "kafka_api_version" {
    type = string
    default = ""
}
  


variable "kafka_kind" {
    type = string
    default = ""
}

variable "confluent_service_account_id" {
    type = string
    default = ""
}

variable "confluent_service_account_api_version" {
    type = string
    default = ""
}

variable "confluent_service_account_kind" {
    type = string
    default = ""
}

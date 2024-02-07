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

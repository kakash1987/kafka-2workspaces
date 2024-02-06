resource "confluent_environment" "staging" {
  display_name = "Staging"
}

output "confluent_environment_id" {
  value = confluent_environment.staging.id
}



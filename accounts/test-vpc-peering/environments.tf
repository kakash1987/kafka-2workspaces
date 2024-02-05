resource "confluent_environment" "staging" {
  display_name = "Staging"
}

output "confluent_environment_id" {
  value = confluent_environment.staging.id
}

resource "confluent_environment" "test" {
  display_name = "Test"
}

output "confluent_environment_test_id" {
  value = confluent_environment.test.id
}

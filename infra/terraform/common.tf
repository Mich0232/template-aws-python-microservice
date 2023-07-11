locals {
  environment     = terraform.workspace == "default" ? "test" : terraform.workspace
  resource_prefix = "${var.microservice_name}-${local.environment}"

  api_default_timeout_ms             = 15000
  api_default_payload_format_version = "2.0"

  tags = {
    Name = var.microservice_name
    Env  = local.environment
  }
}
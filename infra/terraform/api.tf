module "api" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "v2.2.2"

  name          = "${local.resource_prefix}-api"
  protocol_type = "HTTP"

  create_api_domain_name = false

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Access logs
  default_stage_access_log_format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "GET /hello" = {
      lambda_arn             = module.service.lambda_function_arn
      payload_format_version = local.api_default_payload_format_version
      timeout_milliseconds   = local.api_default_timeout_ms
    }

    "GET /hello/{name}" = {
      lambda_arn             = module.service.lambda_function_arn
      payload_format_version = local.api_default_payload_format_version
      timeout_milliseconds   = local.api_default_timeout_ms
    }

    "$default" = {
      lambda_arn             = module.service.lambda_function_arn
      payload_format_version = local.api_default_payload_format_version
      timeout_milliseconds   = local.api_default_timeout_ms
    }
  }

  tags = local.tags
}
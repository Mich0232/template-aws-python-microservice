module "deployment_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "v3.14.0"

  bucket = "${local.resource_prefix}-deployment-bucket"

  tags = local.tags
}

module "service" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v5.2.0"

  function_name = "${local.resource_prefix}-api"
  handler       = "app.lambda_handler"
  runtime       = var.python_version
  publish       = true

  source_path = [
    {
      path             = "${path.cwd}/../../src",
      pip_requirements = false,
      poetry_install   = false
    }
  ]

  store_on_s3 = true
  s3_bucket   = module.deployment_bucket.s3_bucket_id
  s3_prefix   = var.microservice_name

  layers = [
    module.layer.lambda_layer_arn,
  ]

  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${module.api.apigatewayv2_api_execution_arn}/*/*/*"
    }
  }

  tags = local.tags
}

module "layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v5.2.0"

  create_layer = true

  layer_name          = "${local.resource_prefix}-layer"
  compatible_runtimes = [var.python_version]
  runtime             = var.python_version

  source_path = [
    "${path.root}/../../requirements.txt",
    {
      pip_requirements = "${path.root}/../../requirements.txt",
      prefix_in_zip    = "python"
    },
  ]

  store_on_s3 = true
  s3_bucket   = module.deployment_bucket.s3_bucket_id
  s3_prefix   = var.microservice_name

  tags = local.tags
}
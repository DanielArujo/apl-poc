
module "iam" {
  source = "./modulesTF/iam"
}

module "dynamo" {
  source                = "./modulesTF/dynamodb"
  dynamodb_name         = "order"
  dynamodb_billing_mode = "PAY_PER_REQUEST"
  dynamodb_ttl_enable   = false
}

module "dynamoDb_user" {
  source                = "./modulesTF/dynamodb"
  dynamodb_name         = "user"
  dynamodb_billing_mode = "PAY_PER_REQUEST"
  dynamodb_ttl_enable   = false
}


module "process_user" {
  source                       = "./modulesTF/lambda/lambda-sqs"
  lambda_name                  = "process-user"
  lambda_handler               = "main"
  lambda_runtime               = "go1.x"
  lambda_memory_size           = 128
  lambda_timeout               = 600
  lambda_role_arn              = module.iam.arn
  lambda_role_name             = module.iam.name
  lambda_filename              = "../bin/persist_user/persist_user.zip"
}


module "proxy" {
  source                       = "./modulesTF/lambda/lambda-gateway"
  lambda_name                  = "lambda-proxy"
  lambda_handler               = "main"
  lambda_runtime               = "go1.x"
  lambda_memory_size           = 128
  lambda_timeout               = 600
  lambda_role_arn              = module.iam.arn
  lambda_role_name             = module.iam.name
  lambda_filename              = "../bin/proxy/proxy.zip"
  api_gateway_root_resource_id = module.api.api_gateway_root_resource_id
  api_gateway_id               = module.api.id
  api_gateway_path             = "{proxy+}"
  api_gateway_environment      = "dev"
  api_http_method              = "ANY"
}

module "api" {
  source = "./modulesTF/api_gateway"
}


module "user_sqs" {
  source                      = "./modulesTF/sqs"
  sqs_queue_topic             = "users"
  sqs_queue_delay_seconds     = 60
  sqs_queue_retention_seconds = 600
  sqs_queue_role              = module.iam.name
  sqs_policy_name             = "lambda-sqs-policy-users"
}

resource "aws_lambda_event_source_mapping" "event_user_mapping" {
  event_source_arn = module.user_sqs.sqs_arn
  function_name    = module.process_user.name_lambda
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [module.proxy.integration]
  rest_api_id = module.api.id
  stage_name  = "dev"
}


output "custom_url" {
  value = module.api.id
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

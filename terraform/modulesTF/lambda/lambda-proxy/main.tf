
# Create the Lambda function
resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = var.lambda_role_arn
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  publish       = true

  # Replace with your Lambda function code
  filename         = var.lambda_filename
  source_code_hash = filebase64sha256(var.lambda_filename)
}

resource "aws_iam_policy_attachment" "lambda_execution" {
  name       = "lambda-execution-policy"
  roles      = [var.lambda_role_name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a resource in the API Gateway
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = var.api_gateway_path
}

# Create a method for the resource
resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.api_http_method
  authorization = "NONE"
}

# Create an integration between the API Gateway and Lambda function
resource "aws_api_gateway_integration" "integration" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  # lambda just create the context with POST
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

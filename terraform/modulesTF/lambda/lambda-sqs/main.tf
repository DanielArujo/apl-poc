
# Create the Lambda function
resource "aws_lambda_function" "lambda_sqs" {
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

output "arn_lambda" {
  value = aws_lambda_function.lambda_sqs.arn
}

output "name_lambda" {
  value = aws_lambda_function.lambda_sqs.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_sqs.invoke_arn
}

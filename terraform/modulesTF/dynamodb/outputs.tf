output "dynamodb_arn" {
  value       = aws_dynamodb_table.dynamodb.arn
  description = "ARN Dynamodb"
}
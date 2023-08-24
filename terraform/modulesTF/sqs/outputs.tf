output "sqs_arn" {
  value       = aws_sqs_queue.sqs_queue.arn
  description = "ARN Queue sqs"
}
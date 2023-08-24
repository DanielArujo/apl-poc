resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.sqs_queue_topic
  delay_seconds              = var.sqs_queue_delay_seconds
  message_retention_seconds  = var.sqs_queue_retention_seconds
  visibility_timeout_seconds = var.sqs_queue_visibility_timeout_seconds
}

# resource "aws_lambda_event_source_mapping" "mapping" {
#   event_source_arn = aws_sqs_queue.sqs_queue.arn
#   function_name    = var.sqs_queue_lambda_trigger
# }

resource "aws_iam_policy" "sqs_policy" {
  name        = var.sqs_policy_name
  description = "Permissions to send SQS messages"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.sqs_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_attach" {
  policy_arn = aws_iam_policy.sqs_policy.arn
  role       = var.sqs_queue_role
}
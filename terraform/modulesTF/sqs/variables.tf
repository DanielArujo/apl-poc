variable "sqs_queue_topic" {
  description = "topic of the sqs queue"
  default     = "sample-topic"
}

variable "sqs_queue_delay_seconds" {
  description = "The length of time, in seconds, for which the delivery of all messages in the queue is delayed."
  default     = 0
}

variable "sqs_queue_retention_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS retains a message."
  default     = 345.600
}

variable "sqs_queue_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue, in seconds"
  default     = 30
}

variable "sqs_queue_lambda_trigger" {
  description = "lambda that will be trigger when receiving a new event in the sqs queue"
  default     = null
}

variable "sqs_queue_role" {
  description = "iam permissions role"
  default     = null
}

variable "sqs_policy_name" {
  description = ""
  default     = null
}

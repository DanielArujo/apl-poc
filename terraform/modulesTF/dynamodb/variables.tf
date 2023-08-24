variable "dynamodb_name" {
  description = "table name in dynamodb"
  default     = "dynamodb_table"
}

variable "dynamodb_billing_mode" {
  description = "dynamodb resource billing mode"
  default     = "dynamodb_billing_mode"
}

variable "dynamodb_ttl_enable" {
  description = "Time to Live is enabled for the table"
  default     = false
}
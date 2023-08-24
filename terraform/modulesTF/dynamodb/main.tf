resource "aws_dynamodb_table" "dynamodb" {
  name         = var.dynamodb_name
  billing_mode = var.dynamodb_billing_mode
  hash_key     = "id"
  table_class  = "STANDARD"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = var.dynamodb_ttl_enable
  }

  server_side_encryption {
    enabled = false
  }
}

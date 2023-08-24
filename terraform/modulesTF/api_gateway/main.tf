# Create the API Gateway REST API
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "api_gateway"
  description = "My REST API"
}


# ###############################
# API Gateway: Resources
# ###############################

# path
resource "aws_api_gateway_resource" "apigw_resource" {
  for_each    = toset(var.path_list)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = each.value
}

# method get
resource "aws_api_gateway_method" "apigw_method_get" {
  for_each      = aws_api_gateway_resource.apigw_resource
  resource_id   = each.value.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.year" = false # false = optional; true = required
    "method.request.querystring.user" = false # false = optional; true = required
  }
}

# get integrate
resource "aws_api_gateway_integration" "apigw_integration_get" {
  for_each                = aws_api_gateway_method.apigw_method_get
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = each.value.resource_id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn

  cache_key_parameters = [
    "method.request.querystring.year",
    "method.request.querystring.user",
  ]

  cache_namespace = each.value.id
}

# get response
resource "aws_api_gateway_method_response" "apigw_method_response_get" {
  for_each    = aws_api_gateway_method.apigw_method_get
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# get integation response
resource "aws_api_gateway_integration_response" "apigw_integration_response_get" {
  for_each    = aws_api_gateway_method_response.apigw_method_response_get
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  status_code = each.value.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method.apigw_method_get,
    aws_api_gateway_integration.apigw_integration_get
  ]
}

# ###############################
# API Gateway: option cors
# ###############################

# option cors
resource "aws_api_gateway_method" "apigw_method_cors" {
  for_each      = aws_api_gateway_resource.apigw_resource
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = each.value.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# option integration: cors
resource "aws_api_gateway_integration" "apigw_integration_cors" {
  for_each    = aws_api_gateway_method.apigw_method_cors
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# option: method response
resource "aws_api_gateway_method_response" "apigw_method_response_get_cors" {
  for_each    = aws_api_gateway_method.apigw_method_cors
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# option integration_response
resource "aws_api_gateway_integration_response" "apigw_integration_response_cors" {
  for_each    = aws_api_gateway_method_response.apigw_method_response_get_cors
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  status_code = each.value.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method.apigw_method_cors,
    aws_api_gateway_integration.apigw_integration_cors
  ]
}

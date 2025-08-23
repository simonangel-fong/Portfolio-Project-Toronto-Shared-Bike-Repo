# ###############################
# API Gateway: get
# ###############################

# path
resource "aws_api_gateway_resource" "apigw_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.path_list[0]
}

# method get
resource "aws_api_gateway_method" "apigw_method_get" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.apigw_resource.id
  http_method = "GET"

  authorization = "NONE"
}

# get integrate
resource "aws_api_gateway_integration" "apigw_integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.apigw_resource.id
  http_method             = aws_api_gateway_method.apigw_method_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_list[0]
}

# get response
resource "aws_api_gateway_method_response" "apigw_method_response_get" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.apigw_resource.id
  http_method = aws_api_gateway_method.apigw_method_get.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# get integation response
resource "aws_api_gateway_integration_response" "apigw_integration_response_get" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.apigw_resource.id
  http_method = aws_api_gateway_method.apigw_method_get.http_method
  status_code = aws_api_gateway_method_response.apigw_method_response_get.status_code


  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
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
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.apigw_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# option integration: cors
resource "aws_api_gateway_integration" "apigw_integration_cors" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.apigw_resource.id
  http_method = aws_api_gateway_method.apigw_method_cors.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# option: method response
resource "aws_api_gateway_method_response" "apigw_method_response_get_cors" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.apigw_resource.id
  http_method = aws_api_gateway_method.apigw_method_cors.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# option integration_response
resource "aws_api_gateway_integration_response" "apigw_integration_response_cors" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.apigw_resource.id
  http_method = aws_api_gateway_method.apigw_method_cors.http_method
  status_code = aws_api_gateway_method_response.apigw_method_response_get_cors.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.apigw_method_cors,
    aws_api_gateway_integration.apigw_integration_cors,
  ]
}

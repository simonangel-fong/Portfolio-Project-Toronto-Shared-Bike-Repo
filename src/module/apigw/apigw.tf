# ###############################
# IAM role for API to invoke lambda service
# ###############################

resource "aws_lambda_permission" "api_gateway_invoke_get" {
  function_name = var.lambda_id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGatewayGET"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

# ###############################
# API Gateway
# ###############################

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.project}-${var.app}-${var.env}-api-gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = 0
}

resource "aws_api_gateway_account" "apigw_account" {
  cloudwatch_role_arn = aws_iam_role.apigw_cloudwatch_role.arn
  depends_on          = [aws_iam_role_policy_attachment.apigw_push_logs]
}

# ###############################
# API Gateway Deployment: a snapshot of the REST API configuration
# ###############################
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  # Redeploy when any method/integration changes
  triggers = {
    redeployment = sha1(jsonencode(
      concat(
        [for method_get in aws_api_gateway_method.apigw_method_get : method_get],
        [for inte_get in aws_api_gateway_integration.apigw_integration_get : inte_get],
        [for resp_get in aws_api_gateway_method_response.apigw_method_response_get : resp_get],
        [for ir_get in aws_api_gateway_integration_response.apigw_integration_response_get : ir_get],
        [for method_cors in aws_api_gateway_method.apigw_method_cors : method_cors],
        [for inte_cors in aws_api_gateway_integration.apigw_integration_cors : inte_cors],
        [for resp_cors in aws_api_gateway_method_response.apigw_method_response_get_cors : resp_cors],
        [for ir_cors in aws_api_gateway_integration_response.apigw_integration_response_cors : ir_cors]
      )
    ))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.apigw_method_get,
    aws_api_gateway_integration.apigw_integration_get,
    aws_api_gateway_method_response.apigw_method_response_get,
    aws_api_gateway_integration_response.apigw_integration_response_get,
    aws_api_gateway_method.apigw_method_cors,
    aws_api_gateway_integration.apigw_integration_cors,
    aws_api_gateway_method_response.apigw_method_response_get_cors,
    aws_api_gateway_integration_response.apigw_integration_response_cors
  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.env
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id

  variables = {
    lambdaAlias = "live"
  }

  # assign log group and format
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  # Enable cache
  cache_cluster_enabled = true
  cache_cluster_size    = "0.5"

  depends_on = [
    aws_cloudwatch_log_group.api_gateway_logs,
    aws_api_gateway_account.apigw_account
  ]
}

#  enable Method-level caching
resource "aws_api_gateway_method_settings" "cached_gets" {
  for_each    = toset(var.path_list)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "${each.value}/GET"

  settings {
    caching_enabled        = true
    cache_ttl_in_seconds   = 60 # start with 60s; tune per endpoint
    cache_data_encrypted   = true
    metrics_enabled        = true    # keep on for tuning; you can disable later
    logging_level          = "ERROR" # cut down on overhead vs "INFO"
    throttling_burst_limit = 1000
    throttling_rate_limit  = 500
  }
}

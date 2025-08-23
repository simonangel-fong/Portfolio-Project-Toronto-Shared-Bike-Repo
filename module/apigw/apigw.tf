
# ###############################
# IAM role for API to invoke lambda service
# ###############################

resource "aws_lambda_permission" "api_gateway_invoke_get" {
  function_name = var.lambda_id_list[0]
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGatewayGET"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

# ###############################
# API Gateway
# ###############################

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.project}-${var.app}-api-gateway"
  description = "${var.project}-${var.app}-api-gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# ###############################
# API Gateway Deployment: a snapshot of the REST API configuration
# ###############################
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  # Redeploy when any method/integration changes
  triggers = {
    redeployment = sha1(jsonencode([
      # GET
      aws_api_gateway_method.apigw_method_get.id,
      aws_api_gateway_integration.apigw_integration_get.id,
      aws_api_gateway_method_response.apigw_method_response_get.id,
      aws_api_gateway_integration_response.apigw_integration_response_get.id,

      # OPTIONS /items
      aws_api_gateway_method.apigw_method_cors.id,
      aws_api_gateway_integration.apigw_integration_cors.id,
      aws_api_gateway_method_response.apigw_method_response_get_cors.id,
      aws_api_gateway_integration_response.apigw_integration_response_cors.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    # GET
    aws_api_gateway_method.apigw_method_get,
    aws_api_gateway_integration.apigw_integration_get,
    aws_api_gateway_method_response.apigw_method_response_get,
    aws_api_gateway_integration_response.apigw_integration_response_get,

    # OPTIONS /items
    aws_api_gateway_method.apigw_method_cors,
    aws_api_gateway_integration.apigw_integration_cors,
    aws_api_gateway_method_response.apigw_method_response_get_cors,
    aws_api_gateway_integration_response.apigw_integration_response_cors,
  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id

  variables = {
    lambdaAlias = "live"
  }

  # access_log_settings {
  #   destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
  #   format = jsonencode({
  #     requestId      = "$context.requestId"
  #     ip             = "$context.identity.sourceIp"
  #     caller         = "$context.identity.caller"
  #     user           = "$context.identity.user"
  #     requestTime    = "$context.requestTime"
  #     httpMethod     = "$context.httpMethod"
  #     resourcePath   = "$context.resourcePath"
  #     status         = "$context.status"
  #     protocol       = "$context.protocol"
  #     responseLength = "$context.responseLength"
  #   })
  # }

  # xray_tracing_enabled  = true
  # cache_cluster_enabled = false

  # depends_on = [
  #   aws_cloudwatch_log_group.api_gateway_logs,
  #   aws_api_gateway_account.account_settings
  # ]
}

data "aws_acm_certificate" "acm_cert" {
  domain      = var.cert_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "api_custom_domain" {
  domain_name              = var.apigw_domain
  regional_certificate_arn = data.aws_acm_certificate.acm_cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

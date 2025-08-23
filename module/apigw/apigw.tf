
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
# API Gateway: List
# ###############################

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.project}-${var.app}-api-gateway"
  description = "${var.project}-${var.app}-api-gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# ###############################
# CloudWatch Log Group
# ###############################
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.project}-${var.app}/${var.env}"
  retention_in_days = 14
}

# ###############################
# IAM role for CloudWatch
# ###############################
resource "aws_iam_role" "apigw_cloudwatch_role" {
  name = "${var.project}-${var.app}-${var.env}-apigw-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole"
      Principal = {
        Service = "apigateway.amazonaws.com"
      },
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apigw_push_logs" {
  role       = aws_iam_role.apigw_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

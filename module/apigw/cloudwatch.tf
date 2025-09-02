# ###############################
# IAM role for CloudWatch
# ###############################
resource "aws_iam_role" "apigw_cloudwatch_role" {
  name = "${var.project}-${var.app}-apigw-cloudwatch-role"

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

# Role policy
resource "aws_iam_role_policy" "apigw_cloudwatch_policy" {
  name = "${var.project}-${var.app}-apigw-cloudwatch-role-policy"
  role = aws_iam_role.apigw_cloudwatch_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.api_gateway_logs.arn}:*"
      }
    ]
  })
}

# ###############################
# CloudWatch Log Group
# ###############################
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.project}-${var.app}/${var.env}"
  retention_in_days = 14
}

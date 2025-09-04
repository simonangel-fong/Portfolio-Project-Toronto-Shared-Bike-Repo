# local variable
locals {
  lambda_function_name = "${var.project}-${var.app}-lambda-function"
}

# ########################################
# CloudWatch Log Group
# ########################################

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 14
}

# ########################################
# Create role for Lambda
# ########################################

resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-${var.app}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# ##############################################
# IAM Policy: Allow Lambda to access DynamoDB
# ##############################################

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "${var.project}-${var.app}-lambda-access-dynamodb-policy"
  description = "Policy for Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # Read permissions
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          # Write permissions for adding new items
          "dynamodb:PutItem",
          "dynamodb:BatchWriteItem",
          # Update permissions (for future use)
          "dynamodb:UpdateItem",
          # Delete permissions (for future use)
          "dynamodb:DeleteItem",
          # METADATA used by the Lambda code (_get_table_pk_name)
          "dynamodb:DescribeTable",
          "dynamodb:ListTables"
        ]
        Resource = flatten([
          for arn in var.dynamodb_table_arn : [
            arn,
            "${arn}/*"
          ]
        ])
      },
      # logging
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# ###############################
# Package function file
# ###############################

data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_file = var.archive_source_file
  output_path = var.archive_output_path
}

# Add dependencies layer
resource "aws_lambda_layer_version" "lambda_function_layer" {
  layer_name               = "${var.project}-${var.app}-lambda-layer"
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64"]

  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_file.source_file)
}

# ###############################
# AWS Lambda function
# ###############################

resource "aws_lambda_function" "lambda_function" {

  function_name    = local.lambda_function_name
  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  handler          = "main.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_role.arn
  timeout          = 30

  # layer
  layers = [aws_lambda_layer_version.lambda_function_layer.arn]

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}

resource "aws_lambda_provisioned_concurrency_config" "example_provisioned_concurrency" {
  function_name                     = aws_lambda_function.lambda_function.function_name
  qualifier                         = "LATEST"
  provisioned_concurrent_executions = 10
}

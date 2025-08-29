output "lambda_arn" {
  value = aws_lambda_function.lambda_function.invoke_arn
}

output "lambda_id" {
  value = aws_lambda_function.lambda_function.id
}

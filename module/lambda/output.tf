output "lambda_arn_list" {
  value = aws_lambda_function.lambda_function.invoke_arn
}

output "lambda_id_list" {
  value = aws_lambda_function.lambda_function.id
}

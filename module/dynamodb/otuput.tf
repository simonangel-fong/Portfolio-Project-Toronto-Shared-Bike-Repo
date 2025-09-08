output "arn" {
  value = [for tb in aws_dynamodb_table.dynamodb_table : tb.arn]
}

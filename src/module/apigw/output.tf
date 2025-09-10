output "id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "stage" {
  value = aws_api_gateway_stage.api_stage.stage_name
}

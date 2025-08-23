# output "apigw_domain" {
#   value = aws_api_gateway_domain_name.api_domain.domain_name
# }

output "apigw_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "apigw_stage" {
  value = aws_api_gateway_stage.api_stage.stage_name
}

output "apigw_invoke_url" {
  value = aws_api_gateway_stage.api_stage.invoke_url
}
# # ########################################
# # S3 bucket stores csv file
# # ########################################
# data "aws_s3_bucket" "csv_bucket" {
#   bucket = var.csv_bucket
# }

# # ##############################
# # AWS VPC
# # ##############################
# module "vpc" {
#   source = "../module/vpc"

#   project    = var.project
#   app        = var.app
#   env        = var.env
#   aws_region = var.aws_region
#   vpc_cidr   = var.vpc_cidr
# }

# # output "vpc_id" { value = module.vpc.aws_vpc_id }

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb" {
  source = "../module/dynamodb"

  project     = var.project
  app         = var.app
  env         = var.env
  dynamodb_tb = var.dynamodb_tb
}

output "dynamodb_tb_arn" { value = module.dynamodb_tb.dynamodb_tb_arn }

# ##############################
# AWS Lambda
# ##############################
module "lambda" {
  source     = "../module/lambda"
  project    = var.project
  app        = var.app
  env        = var.env
  aws_region = var.aws_region

  archive_source_file = "${path.module}/../lambda/main.py"
  archive_output_path = "${path.module}/../lambda/main.zip"
  layer_runtimes      = ["python3.12"]
  # function_name       = "${var.project}-${var.app}-lambda-function"
  function_handler   = "main.lambda_handler"
  dynamodb_table_arn = module.dynamodb_tb.dynamodb_tb_arn
}

# # output "lambda_arn_list" { value = module.lambda.lambda_arn_list }

# # output "lambda_id_list" { value = module.lambda.lambda_id_list }

# # ##############################
# # AWS API Gateway
# # ##############################
# module "api_gateway" {
#   source     = "../module/apigw"
#   project    = var.project
#   app        = var.app
#   env        = var.env
#   aws_region = var.aws_region

#   path_list       = ["bike-count"]
#   lambda_arn_list = [module.lambda.lambda_arn_list]
#   lambda_id_list  = [module.lambda.lambda_id_list]
#   cert_domain     = "*.arguswatcher.net"
#   apigw_domain    = "test-api.arguswatcher.net"
# }

# output "apigw_id" {
#   value = module.api_gateway.apigw_id
# }

# output "apigw_stage" {
#   value = module.api_gateway.apigw_stage
# }

# # ##############################
# # AWS Cloudfront
# # ##############################
# module "cloudfront" {
#   source     = "../module/cloudfront"
#   project    = var.project
#   app        = var.app
#   env        = var.env
#   aws_region = var.aws_region

#   dns_domain  = "test-api.arguswatcher.net"
#   cert_domain = "*.arguswatcher.net"
#   apigw_stage = module.api_gateway.apigw_stage
#   apigw_id    = module.api_gateway.apigw_id
# }

# output "cf_domain" {
#   value = module.cloudfront.cf_domain
# }

# module "cloudflare_dns" {
#   source     = "../module/dns"
#   project    = var.project
#   app        = var.app
#   env        = var.env
#   aws_region = var.aws_region

#   cloudflare_zone_id = "ceed00499bed9aba313f36acf8100262"
#   dns_domain         = "test-api.arguswatcher.net"
#   cf_domain          = module.cloudfront.cf_domain
# }

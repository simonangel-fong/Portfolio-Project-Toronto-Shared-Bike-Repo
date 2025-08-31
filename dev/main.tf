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
# AWS S3 bucket
# ##############################
module "csv_bucket" {
  source = "../module/s3"

  project  = var.project
  app      = var.app
  env      = var.env
  csv_path = var.csv_path
  web_path = var.web_path
}

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb" {
  source = "../module/dynamodb"

  project    = var.project
  app        = var.app
  env        = var.env
  csv_bucket = module.csv_bucket.id
  csv_prefix = var.csv_prefix
}

# ##############################
# AWS Lambda
# ##############################
module "lambda" {
  source     = "../module/lambda"
  project    = var.project
  app        = var.app
  env        = var.env

  archive_source_file = "${path.module}/../lambda/main.py"
  archive_output_path = "${path.module}/../lambda/main.zip"
  dynamodb_table_arn  = module.dynamodb_tb.arn
}

# ##############################
# AWS API Gateway
# ##############################
module "api_gateway" {
  source     = "../module/apigw"
  project    = var.project
  app        = var.app
  env        = var.env

  path_list  = var.path_list
  lambda_arn = module.lambda.arn
  lambda_id  = module.lambda.id
}

# # ##############################
# # AWS Cloudfront
# # ##############################
# module "cloudfront" {
#   source     = "../module/cloudfront"
#   project    = var.project
#   app        = var.app
#   env        = var.env
#   aws_region = var.aws_region

#   dns_domain  = var.apigw_domain
#   cert_domain = var.cert_domain
#   apigw_stage = module.api_gateway.apigw_stage
#   apigw_id    = module.api_gateway.apigw_id
# }

# output "name" {
#   value = module.cloudfront.cf_domain
# }

# module "cloudflare_dns" {
#   source     = "../module/dns"
#   project    = var.project
#   app        = var.app
#   env        = var.env
#   aws_region = var.aws_region

#   cloudflare_zone_id   = var.cloudflare_zone_id
#   cloudflare_api_token = var.cloudflare_api_token
#   dns_domain           = var.apigw_domain
#   target_domain        = module.cloudfront.cf_domain
# }

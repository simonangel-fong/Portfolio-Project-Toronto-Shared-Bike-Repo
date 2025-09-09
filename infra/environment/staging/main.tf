# ##############################
# AWS S3 bucket
# ##############################
module "stage_csv_bucket" {
  source  = "../../module/s3"
  project = var.project
  app     = var.app
  env     = var.env

  csv_path = var.csv_path
  web_path = var.web_path
}

# # ##############################
# # AWS Dynamodb
# # ##############################
# module "stage_dynamodb_tb" {
#   source  = "../../module/dynamodb"
#   project = var.project
#   app     = var.app
#   env     = var.env

#   csv_bucket = module.stage_csv_bucket.id
#   csv_prefix = var.csv_prefix
# }

# # ##############################
# # AWS Lambda
# # ##############################
# module "stage_lambda" {
#   source  = "../../module/lambda"
#   project = var.project
#   app     = var.app
#   env     = var.env

#   archive_source_file = "${path.module}/../../../src/lambda/main.py"
#   archive_output_path = "${path.module}/../../../src/lambda/main.zip"
#   dynamodb_table_arn  = module.stage_dynamodb_tb.arn
# }

# # ##############################
# # AWS API Gateway
# # ##############################
# module "stage_apigw" {
#   source  = "../../module/apigw"
#   project = var.project
#   app     = var.app
#   env     = var.env

#   path_list  = var.path_list
#   lambda_arn = module.stage_lambda.arn
#   lambda_id  = module.stage_lambda.id
# }

# # ##############################
# # AWS Cloudfront
# # ##############################
# module "cloudfront" {
#   source  = "../../module/cloudfront"
#   project = var.project
#   app     = var.app
#   env     = var.env

#   # domain
#   dns_domain  = var.dns_domain
#   cert_domain = var.cert_domain
#   # api
#   apigw_stage = module.stage_apigw.stage
#   apigw_id    = module.stage_apigw.id
#   # s3 web
#   website_endpoint = module.stage_csv_bucket.website_endpoint
# }

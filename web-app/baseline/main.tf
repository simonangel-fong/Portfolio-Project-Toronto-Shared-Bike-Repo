# ##############################
# AWS S3 bucket
# ##############################
module "web_bucket" {
  source        = "../module/s3"
  project       = var.project
  app           = var.app
  env           = var.env
  web_file_path = var.web_file_path
}

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb" {
  source  = "../module/dynamodb"
  project = var.project
  app     = var.app
  env     = var.env

  data_bucket   = var.data_bucket
  data_file_key = var.data_file_key
}

# ##############################
# AWS Lambda
# ##############################
module "lambda" {
  source  = "../module/lambda"
  project = var.project
  app     = var.app
  env     = var.env

  archive_source_file = "../lambda/main.py"
  archive_output_path = "../lambda/main.zip"
  dynamodb_table_arn  = module.dynamodb_tb.arn
}

# ##############################
# AWS API Gateway
# ##############################
module "api_gateway" {
  source  = "../module/apigw"
  project = var.project
  app     = var.app
  env     = var.env

  path_list  = var.path_list
  lambda_arn = module.lambda.arn
  lambda_id  = module.lambda.id
}
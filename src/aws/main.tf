# ##############################
# AWS S3 bucket
# ##############################
module "csv_bucket" {
  source  = "../module/s3"
  project = var.project
  app     = var.app
  env     = var.env

  csv_path = var.csv_path
  web_path = var.web_path
}

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb" {
  source  = "../module/dynamodb"
  project = var.project
  app     = var.app
  env     = var.env

  csv_bucket = module.csv_bucket.id
  csv_list   = module.csv_bucket.csv_list
}

# ##############################
# AWS Lambda
# ##############################
module "lambda" {
  source  = "../module/lambda"
  project = var.project
  app     = var.app
  env     = var.env

  archive_source_file = "${path.module}/../../src/lambda/main.py"
  archive_output_path = "${path.module}/../../src/lambda/main.zip"
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

# ##############################
# AWS Cloudfront
# ##############################
module "cloudfront" {
  source  = "../module/cloudfront"
  project = var.project
  app     = var.app
  env     = var.env

  # domain
  dns_domain  = var.dns_domain
  cert_domain = var.cert_domain
  # api
  apigw_stage = module.api_gateway.stage
  apigw_id    = module.api_gateway.id
  # s3 web
  website_endpoint = module.csv_bucket.website_endpoint
}

# ##############################
# Cloudflare DNS
# ##############################
module "cloudflare_dns" {
  source  = "../module/dns"
  project = var.project
  app     = var.app
  env     = var.env
  # cloudflare config
  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token
  dns_domain           = var.dns_domain
  target_domain        = module.cloudfront.domain
}

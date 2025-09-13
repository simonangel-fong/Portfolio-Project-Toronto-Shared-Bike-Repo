# ##############################
# AWS S3 bucket
# ##############################
module "web_bucket" {
  source        = "../../module/s3"
  project       = var.project
  app           = var.app
  env           = var.env
  web_file_path = var.web_file_path
}

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb" {
  source  = "../../module/dynamodb"
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
  source  = "../../module/lambda"
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
  source  = "../../module/apigw"
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
  source  = "../../module/cloudfront"
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
  website_endpoint = module.web_bucket.website_endpoint
}

# ##############################
# Cloudflare DNS
# ##############################
module "cloudflare_dns" {
  source  = "../../module/dns"
  project = var.project
  app     = var.app
  env     = var.env
  # cloudflare config
  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token
  dns_domain           = var.dns_domain
  target_domain        = module.cloudfront.domain
}

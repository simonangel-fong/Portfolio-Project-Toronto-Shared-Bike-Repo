# ##############################
# AWS S3 bucket
# ##############################
module "web_bucket_base" {
  source        = "../web-app/module/s3"
  project       = var.project
  app           = var.app
  env           = var.env_base
  web_file_path = var.web_file_path_base
}

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb_base" {
  source  = "../web-app/module/dynamodb"
  project = var.project
  app     = var.app
  env     = var.env_base

  data_bucket   = var.data_bucket
  data_file_key = var.data_file_key
}

# ##############################
# AWS Lambda
# ##############################
module "lambda_base" {
  source  = "../web-app/module/lambda"
  project = var.project
  app     = var.app
  env     = var.env_base

  archive_source_file = "../web-app/lambda/main.py"
  archive_output_path = "../web-app/lambda/main.zip"
  dynamodb_table_arn  = module.dynamodb_tb_base.arn
}

# ##############################
# AWS API Gateway
# ##############################
module "api_gateway_base" {
  source  = "../web-app/module/apigw"
  project = var.project
  app     = var.app
  env     = var.env_base

  path_list  = var.path_list
  lambda_arn = module.lambda_base.arn
  lambda_id  = module.lambda_base.id
}

# ##############################
# AWS Cloudfront
# ##############################
module "cloudfront_base" {
  source  = "../web-app/module/cloudfront"
  project = var.project
  app     = var.app
  env     = var.env_base

  # domain
  dns_domain  = var.dns_domain_base
  cert_domain = var.cert_domain
  # api
  apigw_stage = module.api_gateway_base.stage
  apigw_id    = module.api_gateway_base.id
  # s3 web
  website_endpoint = module.web_bucket_base.website_endpoint
}

# ##############################
# Cloudflare DNS
# ##############################
module "cloudflare_dns_base" {
  source  = "../web-app/module/dns"
  project = var.project
  app     = var.app
  env     = var.env_base
  # cloudflare config
  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token
  dns_domain           = var.dns_domain_base
  target_domain        = module.cloudfront_base.domain
}

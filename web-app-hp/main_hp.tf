# ##############################
# AWS S3 bucket
# ##############################
module "web_bucket_hp" {
  source        = "../web-app/module/s3"
  project       = var.project
  app           = var.app
  env           = var.env_hp
  web_file_path = var.web_file_path_hp
}

# ##############################
# AWS Dynamodb
# ##############################
module "dynamodb_tb_hp" {
  source  = "../web-app/module/dynamodb"
  project = var.project
  app     = var.app
  env     = var.env_hp

  data_bucket   = var.data_bucket
  data_file_key = var.data_file_key
}

# ##############################
# AWS Lambda
# ##############################
module "lambda_hp" {
  source  = "../web-app/module/lambda"
  project = var.project
  app     = var.app
  env     = var.env_hp

  archive_source_file = "../web-app/lambda/main.py"
  archive_output_path = "../web-app/lambda/main.zip"
  dynamodb_table_arn  = module.dynamodb_tb_hp.arn
}

# ##############################
# AWS API Gateway
# ##############################
module "api_gateway_hp" {
  source  = "../web-app/module/apigw_hp" // hp apis
  project = var.project
  app     = var.app
  env     = var.env_hp

  path_list  = var.path_list
  lambda_arn = module.lambda_hp.arn
  lambda_id  = module.lambda_hp.id
}

# ##############################
# AWS Cloudfront
# ##############################
module "cloudfront_hp" {
  source  = "../web-app/module/cloudfront_hp"
  project = var.project
  app     = var.app
  env     = var.env_hp

  # domain
  dns_domain  = var.dns_domain_hp
  cert_domain = var.cert_domain
  # api
  apigw_stage = module.api_gateway_hp.stage
  apigw_id    = module.api_gateway_hp.id
  # s3 web
  website_endpoint = module.web_bucket_hp.website_endpoint
}

# ##############################
# Cloudflare DNS
# ##############################
module "cloudflare_dns_hp" {
  source  = "../web-app/module/dns"
  project = var.project
  app     = var.app
  env     = var.env_hp
  # cloudflare config
  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token
  dns_domain           = var.dns_domain_hp
  target_domain        = module.cloudfront_hp.domain
}

# ##############################
# App
# ##############################
variable "project" { default = "toronto-shared-bike" }
variable "app" { default = "data-warehouse" }
variable "env" { default = "dev" }
variable "aws_region" { type = string }
variable "dns_domain" { default = "test-api.arguswatcher.net" }

# ##############################
# S3 bucket
# ##############################
variable "csv_path" { default = "../csv" }
variable "web_path" { default = "../web" }

# ##############################
# DynamoDB Table
# ##############################
variable "csv_prefix" { default = "data" }

# ##############################
# API Gateway
# ##############################
variable "path_list" {
  default = [
    "trip-hour",
    "trip-month",
    "top-station",
    "bike",
    "station"
  ]
}

# ##############################
# Cloudfront
# ##############################
variable "cert_domain" { default = "*.arguswatcher.net" }

# ##############################
# Cloudflare
# ##############################
variable "cloudflare_api_token" { type = string }
variable "cloudflare_zone_id" { type = string }


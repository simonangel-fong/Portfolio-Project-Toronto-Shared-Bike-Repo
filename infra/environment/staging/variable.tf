# ##############################
# App
# ##############################
variable "project" { default = "toronto-shared-bike" }
variable "app" { default = "data-warehouse" }
variable "env" { default = "staging" }
variable "aws_region" { type = string }
variable "dns_domain" { default = "trip-dev.arguswatcher.net" }

# ##############################
# S3 bucket
# ##############################
variable "csv_path" { default = "../../../data/csv" }
variable "web_path" { default = "../../../src/web" }

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


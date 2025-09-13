# ##############################
# App
# ##############################
variable "project" {
  type    = string
  default = "toronto-shared-bike"
}
variable "app" {
  type    = string
  default = "data-warehouse"
}
variable "env" {
  type    = string
  default = "dev"
}
variable "aws_region" { type = string }
variable "dns_domain" {
  type    = string
  default = "trip-dev.arguswatcher.net"
}

# ##############################
# S3 bucket
# ##############################
variable "csv_path" {
  type    = string
  default = "../../data/csv"
}
variable "web_path" {
  type    = string
  default = "../../src/web"
}

# ##############################
# DynamoDB Table
# ##############################
variable "csv_prefix" {
  type    = string
  default = "data"
}

# ##############################
# API Gateway
# ##############################
variable "path_list" {
  type = list(string)
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
variable "cert_domain" {
  type    = string
  default = "*.arguswatcher.net"
}

# ##############################
# Cloudflare
# ##############################
variable "cloudflare_api_token" { type = string }
variable "cloudflare_zone_id" { type = string }


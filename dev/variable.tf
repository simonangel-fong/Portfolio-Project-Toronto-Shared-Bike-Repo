# ##############################
# App
# ##############################
variable "project" { default = "toronto-shared-bike" }
variable "app" { default = "data-warehouse" }
variable "env" { default = "dev" }
variable "aws_region" { type = string }

variable "vpc_cidr" { type = string }

# ##############################
# S3 bucket
# ##############################
variable "csv_path" { default = "../csv" }
variable "web_path" { default = "../web" }

# ##############################
# DynamoDB Table
# ##############################
variable "csv_prefix" { default = "data" }


# locals {
#   dynamodb_tb = [
#     {
#       tb_name        = "mv_bike_count"
#       hash_attr      = "pk"
#       hash_attr_type = "S"
#       csv_bucket_id  = "trip.arguswatcher.net"
#       csv_key        = "data/mv_bike_count.csv"
#     },
#     {
#       tb_name        = "mv_station_count"
#       hash_attr      = "pk"
#       hash_attr_type = "S"
#       csv_bucket_id  = "trip.arguswatcher.net"
#       csv_key        = "data/mv_station_count.csv"
#     },
#     {
#       tb_name        = "mv_user_year_hour_trip"
#       hash_attr      = "pk"
#       hash_attr_type = "S"
#       csv_bucket_id  = "trip.arguswatcher.net"
#       csv_key        = "data/mv_user_year_hour_trip.csv"
#     },
#     {
#       tb_name        = "mv_user_year_month_trip"
#       hash_attr      = "pk"
#       hash_attr_type = "S"
#       csv_bucket_id  = "trip.arguswatcher.net"
#       csv_key        = "data/mv_user_year_month_trip.csv"
#     },
#     {
#       tb_name        = "mv_user_year_station"
#       hash_attr      = "pk"
#       hash_attr_type = "S"
#       csv_bucket_id  = "trip.arguswatcher.net"
#       csv_key        = "data/mv_user_year_station.csv"
#     }
#   ]
# }

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
variable "cert_domain" { default = "*.arguswatcher.net" }
variable "apigw_domain" { default = "test-api.arguswatcher.net" }

# ##############################
# Cloudflare
# ##############################
variable "cloudflare_api_token" { type = string }
variable "cloudflare_zone_id" { type = string }


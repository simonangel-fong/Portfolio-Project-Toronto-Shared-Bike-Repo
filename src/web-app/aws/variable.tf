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
variable "web_file_path" {
  type    = string
  default = "../html"
}

# ##############################
# DynamoDB Table
# ##############################
variable "data_bucket" {
  type    = string
  default = "toronto-shared-bike-data-warehouse-data-bucket"
}

variable "data_file_key" {
  type = list(string)
  default = [
    "csv/mv_bike_year.csv"
    , "csv/mv_station_year.csv"
    , "csv/mv_top_station_user_year.csv"
    , "csv/mv_trip_user_year_hour.csv"
    , "csv/mv_trip_user_year_month.csv"
  ]
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


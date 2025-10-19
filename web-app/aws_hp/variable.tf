# ##############################
# App
# ##############################
variable "project" {
  type    = string
  default = "toronto-shared-bike"
}
variable "app" {
  type    = string
  default = "web-app"
}
variable "env" {
  type    = string
  default = "baseline"
}
variable "aws_region" { type = string }
variable "dns_domain" {
  type    = string
  default = "trip-baseline.arguswatcher.net"
}

# ##############################
# S3 bucket
# ##############################
variable "web_file_path" {
  type    = string
  default = "./html"
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
    "mv/mv_bike_year.csv"
    , "mv/mv_station_year.csv"
    , "mv/mv_top_station_user_year.csv"
    , "mv/mv_trip_user_year_hour.csv"
    , "mv/mv_trip_user_year_month.csv"
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


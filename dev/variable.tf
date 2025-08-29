variable "project" { default = "Toronto-shared-bike" }
variable "app" { default = "data-warehouse" }
variable "env" { default = "dev" }
variable "aws_region" { type = string }

variable "vpc_cidr" { type = string }
variable "csv_bucket" { default = "trip.arguswatcher.net" }

variable "dynamodb_table_arn" { type = string }
variable "cloudflare_api_token" { type = string }

variable "dynamodb_tb" {
  default = [
    {
      tb_name        = "mv_bike_count"
      hash_attr      = "pk"
      hash_attr_type = "S"
      csv_bucket_id  = "trip.arguswatcher.net"
      csv_key        = "data/mv_bike_count.csv"
    },
    {
      tb_name        = "mv_station_count"
      hash_attr      = "pk"
      hash_attr_type = "S"
      csv_bucket_id  = "trip.arguswatcher.net"
      csv_key        = "data/mv_station_count.csv"
    },
    {
      tb_name        = "mv_user_year_hour_trip"
      hash_attr      = "pk"
      hash_attr_type = "S"
      csv_bucket_id  = "trip.arguswatcher.net"
      csv_key        = "data/mv_user_year_hour_trip.csv"
    },
    {
      tb_name        = "mv_user_year_month_trip"
      hash_attr      = "pk"
      hash_attr_type = "S"
      csv_bucket_id  = "trip.arguswatcher.net"
      csv_key        = "data/mv_user_year_month_trip.csv"
    },
    {
      tb_name        = "mv_user_year_station"
      hash_attr      = "pk"
      hash_attr_type = "S"
      csv_bucket_id  = "trip.arguswatcher.net"
      csv_key        = "data/mv_user_year_station.csv"
    }
  ]
}

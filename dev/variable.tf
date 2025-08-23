variable "project" { default = "Toronto-shared-bike" }
variable "app" { default = "data-warehouse" }
variable "env" { default = "dev" }

variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "csv_bucket" { type = string }

variable "dynamodb_table_arn" { type = string }
variable "cloudflare_api_token" { type = string }

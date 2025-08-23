module "vpc" {
  source = "../module/vpc"

  project    = var.project
  app        = var.app
  env        = var.env
  aws_region = var.aws_region
  vpc_cidr   = var.vpc_cidr
}

output "vpc_id" { value = module.vpc.aws_vpc_id }

module "dynamodb_bike_count" {
  source = "../module/dynamodb"

  project    = var.project
  app        = var.app
  env        = var.env
  aws_region = var.aws_region

  csv_bucket         = var.csv_bucket
  csv_prefix         = "data/mv_bike_count.csv"
  dynamodb_tb        = "bike-count"
  dynamodb_key       = "dim_year"
  dynamodb_attr      = "dim_year"
  dynamodb_attr_type = "N"
}

output "dynamodb_tb_arn" {
  value = module.dynamodb_bike_count.dynamodb_tb_arn
}

module "lambda" {
  source     = "../module/lambda"
  project    = var.project
  app        = var.app
  env        = var.env
  aws_region = var.aws_region

  archive_source_file = "${path.module}/../lambda/main.py"
  archive_output_path = "${path.module}/../lambda/main.zip"
  layer_runtimes      = ["python3.12"]
  # function_name       = "${var.project}-${var.app}-lambda-function"
  function_handler    = "main.lambda_handler"
  dynamodb_table_arn  = module.dynamodb_bike_count.dynamodb_tb_arn

}

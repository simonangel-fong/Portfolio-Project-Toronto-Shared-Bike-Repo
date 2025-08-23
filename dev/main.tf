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

  s3_bucket          = var.s3_bucket
  s3_bucket_key      = "data/mv_bike_count.csv"
  dynamodb_tb        = "bike-count"
  dynamodb_key       = "dim_year"
  dynamodb_attr      = "dim_year"
  dynamodb_attr_type = "N"
}

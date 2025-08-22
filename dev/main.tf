module "vpc" {
  source = "../module/vpc"

  project    = var.project
  app        = var.app
  env        = var.env
  aws_region = var.aws_region
  vpc_cidr   = var.vpc_cidr
}

output "vpc_id" { value = module.vpc.aws_vpc_id }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.9.8"

  backend "s3" {
    bucket  = ""
    key     = ""
    region  = ""
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  # default tags  
  default_tags {
    tags = {
      App         = var.app
      Environment = var.env
      Project     = var.project
      ManagedBy   = "terraform"
    }
  }
}

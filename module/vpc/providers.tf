terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  # default tags  
  default_tags {
    tags = {
      Project     = var.project
      App         = var.app
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }

}

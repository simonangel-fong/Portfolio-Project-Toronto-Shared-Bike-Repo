variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "aws_region" { type = string }

variable "lambda_arn" { type = string }
variable "lambda_id" { type = string }

variable "cert_domain" { type = string }
variable "apigw_domain" { type = string }

variable "path_list" { type = list(string) }

variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "aws_region" { type = string }

variable "path_list" { type = list(string) }
variable "lambda_arn_list" { type = list(string) }
variable "lambda_id_list" { type = list(string) }

variable "cert_domain" { type = string }
variable "apigw_domain" { type = string }

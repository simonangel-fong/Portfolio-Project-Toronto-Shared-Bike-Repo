variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }

variable "path_list" { type = list(string) }
variable "lambda_arn" { type = string }
variable "lambda_id" { type = string }

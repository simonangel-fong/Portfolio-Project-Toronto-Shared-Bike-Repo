variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "aws_region" { type = string }

variable "archive_source_file" { type = string }
variable "archive_output_path" { type = string }
variable "layer_runtimes" { type = list(string) }
# variable "function_name" { type = string }
variable "function_handler" { type = string }
variable "dynamodb_table_arn" { type = string }

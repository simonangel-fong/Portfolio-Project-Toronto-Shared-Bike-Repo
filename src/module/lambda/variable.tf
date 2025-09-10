variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }

variable "dynamodb_table_arn" { type = list(string) }
variable "archive_source_file" { type = string }
variable "archive_output_path" { type = string }

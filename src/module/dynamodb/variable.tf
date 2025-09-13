variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }

variable "csv_bucket" { type = string }
variable "csv_prefix" { type = string }
variable "csv_file" { type = list(string) }

variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }

variable "csv_path" { type = string }
variable "web_path" { type = string }

locals {
  bucket_name = "${var.project}-${var.app}-${var.env}-bucket"
}

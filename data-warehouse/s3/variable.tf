variable "aws_region" { type = string }
variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "csv_path" {
  type    = string
  default = "../csv"
}
variable "key_prefix" {
  type    = string
  default = "csv"
}

locals {
  bucket_name = "${var.project}-${var.app}-${var.env}-bucket"
}

variable "project" {
  type    = string
  default = "Toronto-shared-bike"
}

variable "app" {
  type    = string
  default = "data-warehouse"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }

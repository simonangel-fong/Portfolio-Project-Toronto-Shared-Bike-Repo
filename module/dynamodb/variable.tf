variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "aws_region" { type = string }
variable "dynamodb_tb" { type = string }
variable "csv_bucket" { type = string }
variable "csv_prefix" { type = string }
variable "dynamodb_key" { type = string }
variable "dynamodb_attr" { type = string }
variable "dynamodb_attr_type" { type = string }


# variable "dynamodb_tb_list" {
#   type = list(
#     object(
#       {
#         tb_name = string
#         bucket     = string
#         prefix     = string
#         csv_file   = string
#         attrs = list({
#           attr = string
#           type = string
#         })
#       }
#     )
#   )
# }

variable "project" { type = string }
variable "app" { type = string }
variable "env" { type = string }
# variable "aws_region" { type = string }

variable "dynamodb_tb" {
  type = list(object({
    tb_name        = string
    hash_attr      = string
    hash_attr_type = string
    csv_bucket_id  = string
    csv_key        = string
  }))
}

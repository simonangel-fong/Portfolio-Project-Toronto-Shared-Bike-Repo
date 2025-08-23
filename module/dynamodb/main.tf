# ########################################
# S3 bucket stores csv file
# ########################################
data "aws_s3_bucket" "csv_bucket" {
  bucket = var.csv_bucket
}

# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  # for_each = var.dynamodb_tb_list
  name         = var.dynamodb_tb
  billing_mode = "PAY_PER_REQUEST"
  region       = var.aws_region

  import_table {
    input_format           = "CSV"
    input_compression_type = "NONE"
    s3_bucket_source {
      bucket     = data.aws_s3_bucket.csv_bucket.id
      key_prefix = var.csv_prefix
    }
  }

  hash_key = var.dynamodb_key

  attribute {
    name = var.dynamodb_attr
    type = var.dynamodb_attr_type
  }

  tags = {
    Name = var.dynamodb_tb
  }
}

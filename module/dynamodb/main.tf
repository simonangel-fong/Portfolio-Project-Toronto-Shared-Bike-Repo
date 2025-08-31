# ########################################
# CSV files
# ########################################

data "aws_s3_objects" "csv_file" {
  bucket = var.csv_bucket
  prefix = var.csv_prefix
}

locals {
  csv_file = data.aws_s3_objects.csv_file.keys
}

# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  for_each = toset(local.csv_file)

  name         = "${var.project}-${var.app}-${var.env}-${split(".", split("/", each.value)[1])[0]}"
  billing_mode = "PAY_PER_REQUEST"

  # key and attribute
  hash_key = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  # import table
  import_table {
    input_format           = "CSV"
    input_compression_type = "NONE"

    s3_bucket_source {
      bucket     = var.csv_bucket
      key_prefix = each.value
    }
  }
}

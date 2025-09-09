locals {
  csv_file = { for idx, f in var.csv_list : f => f }
}

data "aws_s3_bucket_objects" "csv_files" {
  bucket = var.csv_bucket
  prefix = "data"
}

# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  # for_each = local.csv_file
  for_each = { for idx, f in var.csv_list : idx => f }
  # for_each = { for f in data.aws_s3_bucket_objects.csv_files.keys : f => f }

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

  depends_on = [data.aws_s3_bucket_objects.csv_files]
}

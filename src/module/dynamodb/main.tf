
# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  for_each = toset(var.data_file_key)

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
      bucket     = var.data_bucket
      key_prefix = each.value
    }
  }
}

# ########################################
# DynamoDB Table
# ########################################

resource "aws_dynamodb_table" "dynamodb_table" {
  for_each = { for t in var.dynamodb_tb : t.tb_name => t }

  name         = "${var.project}-${var.app}-${var.env}-${each.value.tb_name}"
  billing_mode = "PAY_PER_REQUEST"

  # key and attribute
  hash_key = each.value.hash_attr

  attribute {
    name = each.value.hash_attr
    type = each.value.hash_attr_type
  }

  # import table
  import_table {
    input_format           = "CSV"
    input_compression_type = "NONE"

    s3_bucket_source {
      bucket     = each.value.csv_bucket_id
      key_prefix = each.value.csv_key
    }
  }
}

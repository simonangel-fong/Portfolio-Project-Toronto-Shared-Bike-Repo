# ########################################
# S3 App bucket
# ########################################

resource "aws_s3_bucket" "csv_bucket" {
  bucket = local.bucket_name
  # force_destroy = true
  tags = {
    Name = local.bucket_name
  }
}

# Enabe bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.csv_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ########################################
# Upload csv files
# ########################################

module "csv_file" {
  source   = "hashicorp/dir/template"
  version  = "1.0.2"
  base_dir = var.csv_path
}

# update S3 object resource for hosting bucket files
resource "aws_s3_object" "csv_file" {
  bucket = aws_s3_bucket.csv_bucket.id

  # loop all files
  for_each     = module.csv_file.files
  key          = "${var.key_prefix}/${each.key}"
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  # ETag of the S3 object
  etag = each.value.digests.md5
}

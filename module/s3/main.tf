resource "aws_s3_bucket" "csv_bucket" {
  bucket = "${var.project}-${var.app}-csv-bucket"

  tags = {
    Name        = "${var.project}-${var.app}-csv-bucket"
    Environment = "Dev"
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
# Upload web files
# ########################################

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = var.csv_path
}

# update S3 object resource for hosting bucket files
resource "aws_s3_object" "csv_file" {
  bucket = aws_s3_bucket.csv_bucket.id

  # loop all files
  for_each     = module.template_files.files
  key          = "data/${each.key}"
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  # ETag of the S3 object
  etag = each.value.digests.md5
}

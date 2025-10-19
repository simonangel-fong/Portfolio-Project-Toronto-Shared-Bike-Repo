# ##############################
# AWS S3 bucket
# ##############################
module "web_bucket" {
  source        = "../module/s3"
  project       = var.project
  app           = var.app
  env           = var.env
  web_file_path = var.web_file_path
}

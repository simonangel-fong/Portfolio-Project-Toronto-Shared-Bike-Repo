output "id" {
  value = aws_s3_bucket.app_bucket.id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

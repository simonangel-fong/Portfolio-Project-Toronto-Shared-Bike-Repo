

data "aws_acm_certificate" "acm_cert" {
  domain      = var.cert_domain
  region      = var.cert_region
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

# locals {
#   s3_origin_id = "cloudfront-s3-${aws_s3_bucket.s3_bucket.bucket}"
# }

# # cloudfron
# resource "aws_cloudfront_distribution" "s3_website_distribution" {
#   origin {
#     domain_name = "todo-app.arguswatcher.net.s3-website.ca-central-1.amazonaws.com"
#     origin_id   = local.s3_origin_id

#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only" # S3 static hosting only supports HTTP
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   enabled             = true
#   default_root_object = "index.html"

#   aliases = ["${var.app_name}.${var.domain_name}"]

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id

#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   price_class = "PriceClass_100"

#   viewer_certificate {
#     acm_certificate_arn      = data.aws_acm_certificate.cf_certificate.arn
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   # tags = {
#   #   Name = "${var.app_name}.${var.domain_name}"
#   # }

#   depends_on = [data.aws_acm_certificate.cf_certificate]
# }

data "aws_region" "current" {}

# acm certificate
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1" # Required for CloudFront ACM
}

data "aws_acm_certificate" "cf_certificate" {
  domain      = var.cert_domain
  provider    = aws.us_east_1
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

# cloudfront
resource "aws_cloudfront_distribution" "api_cdn" {
  origin {
    origin_id   = "apigw"
    domain_name = "${var.apigw_id}.execute-api.${data.aws_region.current.region}.amazonaws.com"
    origin_path = "/${var.apigw_stage}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "apigw"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true

    # Forwards CORS-related headers
    forwarded_values {
      query_string = true # Enable query string forwarding

      # Headers for CORS
      headers = [
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "Origin",
        "Authorization",
        "Content-Type"
      ]

      cookies {
        forward = "none"
      }
    }
  }

  enabled             = true
  default_root_object = ""
  aliases             = ["${var.dns_domain}"]
  price_class         = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cf_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [data.aws_acm_certificate.cf_certificate]
}

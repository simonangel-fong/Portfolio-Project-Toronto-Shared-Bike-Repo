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

locals {
  s3_web = "${var.project}-${var.app}-${var.env}-s3-web"
  api_gw = "${var.project}-${var.app}-${var.env}-apigw"
}

# ###############################
# CloudFront
# ###############################
# tfsec:ignore:aws-cloudfront-enable-waf
resource "aws_cloudfront_distribution" "api_cdn" {

  # s3 web hosting
  origin {
    origin_id   = local.s3_web
    domain_name = var.website_endpoint

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # S3 website endpoint supports HTTP only
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # api gateway
  origin {
    origin_id   = local.api_gw
    domain_name = "${var.apigw_id}.execute-api.${data.aws_region.current.region}.amazonaws.com"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # default cache: s3 web
  default_cache_behavior {
    target_origin_id       = local.s3_web
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # ordered cache
  ordered_cache_behavior {
    path_pattern           = "/${var.apigw_stage}/*"
    target_origin_id       = local.api_gw
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true

    forwarded_values {
      query_string = true
      headers = [
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "Origin",
        "Authorization",
        "Content-Type"
      ]
      cookies { forward = "none" }
    }
  }

  enabled             = true
  default_root_object = "index.html"
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

  tags = {
    Name = "${var.project}-${var.app}-${var.env}-cloudfront"
  }
}

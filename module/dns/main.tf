# ########################################
# Cloudflare
# ########################################

resource "cloudflare_record" "cf_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_domain
  content = var.cf_domain
  type    = "CNAME"

  ttl     = 1
  proxied = true
}
# ########################################
# Cloudflare
# ########################################

resource "cloudflare_record" "dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_domain
  content = var.target_domain
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

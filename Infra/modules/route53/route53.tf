# -----------------------------
# Look up existing hosted zone
# -----------------------------
data "aws_route53_zone" "existing" {
  count        = var.create_zone || var.hosted_zone_id != "" ? 0 : 1
  name         = var.zone_name
  private_zone = false
}

# -----------------------------
# Or create a new hosted zone
# -----------------------------
resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0
  name  = var.zone_name
}

# -----------------------------
# Local to resolve the zone ID
# -----------------------------
locals {
  selected_zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : (
    var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.existing[0].zone_id
  )
}

# -----------------------------
# A Record pointing to ALB
# -----------------------------
resource "aws_route53_record" "app" {
  zone_id = local.selected_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
variable "domain_name" {
  type = string
}

variable "hosted_zone_name" {
  type        = string
  default     = ""
  description = "Public hosted zone DNS name (e.g. networking-lab.uk). Leave blank if hosted_zone_id is set."
}

variable "hosted_zone_id" {
  type        = string
  default     = ""
  description = "Public hosted zone ID (starts with Z). Preferred when name lookup fails."
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

locals {
  use_zone_id = trimspace(var.hosted_zone_id) != ""
}

data "aws_route53_zone" "by_id" {
  count   = local.use_zone_id ? 1 : 0
  zone_id = var.hosted_zone_id
}

data "aws_route53_zone" "by_name" {
  count        = local.use_zone_id ? 0 : 1
  name         = trimspace(var.hosted_zone_name)
  private_zone = false
}

locals {
  selected_zone_id = local.use_zone_id ? data.aws_route53_zone.by_id[0].zone_id : data.aws_route53_zone.by_name[0].zone_id
}

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

output "zone_id" {
  value = local.selected_zone_id
}

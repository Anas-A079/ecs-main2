variable "zone_name" {
  description = "The Route53 hosted zone domain name (e.g. example.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Optional hosted zone ID. When set, skips name lookup."
  type        = string
  default     = ""
}

variable "create_zone" {
  description = "Set to true to create a new hosted zone, false to look up an existing one"
  type        = bool
  default     = false # most common case — zone already exists in AWS
}

variable "domain_name" {
  description = "The DNS record name (e.g. app.example.com)"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  type        = string
}
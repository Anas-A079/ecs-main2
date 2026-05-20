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
variable "app_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "container_port" {
  type = number
}

variable "certificate_arn" {
  type        = string
  description = "Existing ACM certificate ARN. Leave empty to create and validate a new certificate via DNS."
  default     = ""
}

variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}
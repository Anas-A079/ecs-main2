variable "app_name" {
  default = "ecs-threatmod"
}

variable "container_port" {
  default = 80
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name"
  type        = string
}

variable "image_url" {
  description = "ECR image URL for ECS task"
  type        = string
}
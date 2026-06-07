variable "app_name" {
  type = string
}

variable "image_url" {
  type = string
}

variable "container_port" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB; ECS tasks accept traffic only from this group"
  type        = string
}

variable "target_group_arn" {
  type = string
}

variable "create_execution_role" {
  type        = bool
  description = "If false, use existing IAM role (same name Terraform would create)."
  default     = false
}

variable "create_cluster" {
  type        = bool
  description = "If false, attach the service to an existing cluster named \"<app_name>-cluster\"."
  default     = true
}
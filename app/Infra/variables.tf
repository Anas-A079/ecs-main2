variable "app_name" {
  default = "ecs-threatmod"
}

variable "container_port" {
  default = 80
}

variable "domain_name" {
  description = "Domain name for the application (example: tm.example.com)"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name (usually the apex domain, example: example.com). Omit if using hosted_zone_id."
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID (starts with Z). Use this when name lookup fails or the zone is not found by hosted_zone_name."
  type        = string
  default     = ""
}

variable "image_url" {
  description = "ECR image URL for ECS task (include tag). Use an empty string for destroy-only runs if your workflow omits it."
  type        = string
  default     = ""
}

variable "create_vpc" {
  description = "If true, create a dedicated VPC. If false, use default VPC / existing VPC (recommended when VPC quota is tight)."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Optional existing VPC ID when create_vpc is false. Leave blank to use the account default VPC."
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "Optional explicit public subnet IDs (>=2). If empty, subnets are discovered automatically."
  type        = list(string)
  default     = []
}

variable "create_ecr_repository" {
  description = "If false, Terraform reads an existing ECR repository matching app_name."
  type        = bool
  default     = false
}

variable "create_ecs_execution_role" {
  description = "If false, Terraform uses existing IAM execution role ecs-threatmod-task-execution-role (or derived from app_name)."
  type        = bool
  default     = false
}

variable "create_ecs_cluster" {
  description = "If false, Terraform targets an existing ECS cluster named \"<app_name>-cluster\"."
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "If set, skips ACM issuance/validation and uses this certificate on the HTTPS listener."
  type        = string
  default     = ""
}

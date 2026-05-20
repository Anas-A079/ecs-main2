variable "create_vpc" {
  type        = bool
  description = "If true, create a dedicated VPC and public subnets. If false, use existing or default VPC."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID to use when create_vpc is false. Leave empty to use default VPC."
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "At least two public subnet IDs in the chosen VPC."
  default     = []
}
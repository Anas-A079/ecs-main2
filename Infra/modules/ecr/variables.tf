variable "app_name" {
  type = string
}

variable "create_repository" {
  type        = bool
  description = "If false, assume the repository already exists and read it via data source."
  default     = false
}
variable "app_name" {
  type = string
}

variable "create_repository" {
  type        = bool
  description = "If false, assume the repository already exists and read it via data source."
  default     = false
}

resource "aws_ecr_repository" "this" {
  count                = var.create_repository ? 1 : 0
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_repository" "this" {
  count = var.create_repository ? 0 : 1
  name  = var.app_name
}

output "repository_url" {
  value = var.create_repository ? aws_ecr_repository.this[0].repository_url : data.aws_ecr_repository.this[0].repository_url
}

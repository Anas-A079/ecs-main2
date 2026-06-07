resource "aws_ecr_repository" "this" {
  count                = var.create_repository ? 1 : 0
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_repository" "existing" {
  count = var.create_repository ? 0 : 1
  name  = var.app_name
}

locals {
  repository_url = var.create_repository ? aws_ecr_repository.this[0].repository_url : data.aws_ecr_repository.existing[0].repository_url
}
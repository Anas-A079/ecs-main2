resource "aws_ecr_repository" "this" {
  count                = var.create_repository ? 1 : 0
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
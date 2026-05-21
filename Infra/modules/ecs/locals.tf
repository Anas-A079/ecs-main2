locals {
  cluster_name        = "${var.app_name}-cluster"
  execution_role_name = "${var.app_name}-ecs-exec-role"
}
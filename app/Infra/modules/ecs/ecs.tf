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

variable "security_group_id" {
  type = string
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

locals {
  cluster_name           = "${var.app_name}-cluster"
  execution_role_name    = "${var.app_name}-task-execution-role"
  execution_role_arn     = var.create_execution_role ? aws_iam_role.ecs_task_execution[0].arn : data.aws_iam_role.ecs_task_execution[0].arn
  cluster_id_for_service = var.create_cluster ? aws_ecs_cluster.this[0].id : data.aws_ecs_cluster.existing[0].id
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  count              = var.create_execution_role ? 1 : 0
  name               = local.execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  count      = var.create_execution_role ? 1 : 0
  role       = aws_iam_role.ecs_task_execution[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_role" "ecs_task_execution" {
  count = var.create_execution_role ? 0 : 1
  name  = local.execution_role_name
}

resource "aws_ecs_cluster" "this" {
  count = var.create_cluster ? 1 : 0
  name  = local.cluster_name
}

data "aws_ecs_cluster" "existing" {
  count        = var.create_cluster ? 0 : 1
  cluster_name = local.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = local.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.image_url
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-service"
  cluster         = local.cluster_id_for_service
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.app_name
    container_port   = var.container_port
  }
}

output "cluster_name" {
  value = local.cluster_name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

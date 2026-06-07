
# -----------------------------
# IAM Assume Role Policy
# -----------------------------
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# -----------------------------
# IAM Role (Execution Role)
# -----------------------------
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

locals {
  execution_role_arn = var.create_execution_role ? aws_iam_role.ecs_task_execution[0].arn : data.aws_iam_role.ecs_task_execution[0].arn
  cluster_id         = var.create_cluster ? aws_ecs_cluster.this[0].id : data.aws_ecs_cluster.existing[0].id
}

# -----------------------------
# ECS Security Group
# -----------------------------
resource "aws_security_group" "ecs" {
  name        = "${var.app_name}-ecs-sg"
  description = "Allow inbound traffic from ALB to ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# ECS Cluster
# -----------------------------
resource "aws_ecs_cluster" "this" {
  count = var.create_cluster ? 1 : 0
  name  = local.cluster_name
}

data "aws_ecs_cluster" "existing" {
  count        = var.create_cluster ? 0 : 1
  cluster_name = local.cluster_name
}

# -----------------------------
# Task Definition
# -----------------------------
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = local.execution_role_arn

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

# -----------------------------
# ECS Service
# -----------------------------
resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-service"
  cluster         = local.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}
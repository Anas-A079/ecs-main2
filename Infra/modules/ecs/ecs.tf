
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

# -----------------------------
# ECS Cluster
# -----------------------------
resource "aws_ecs_cluster" "this" {
  count = var.create_cluster ? 1 : 0
  name  = local.cluster_name
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

  execution_role_arn = var.create_execution_role ? aws_iam_role.ecs_task_execution[0].arn : null

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
  cluster         = aws_ecs_cluster.this[0].id
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

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}
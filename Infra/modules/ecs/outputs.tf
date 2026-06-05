output "cluster_name" {
  value = local.cluster_name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "ecs_security_group_id" {
  description = "Security group ID used by ECS tasks"
  value       = aws_security_group.ecs.id
}
output "cluster_name" {
  value = local.cluster_name
}

output "service_name" {
  value = aws_ecs_service.this.name
}
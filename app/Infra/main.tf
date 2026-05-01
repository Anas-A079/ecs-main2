locals {
  use_existing_certificate   = trimspace(var.certificate_arn) != ""
  use_hosted_zone_id         = trimspace(var.hosted_zone_id) != ""
  validated_certificate_arn  = local.use_existing_certificate ? var.certificate_arn : aws_acm_certificate_validation.app_cert_validation[0].certificate_arn
  route53_validation_zone_id = local.use_hosted_zone_id ? data.aws_route53_zone.acm_lookup_by_id[0].zone_id : data.aws_route53_zone.acm_lookup_by_name[0].zone_id
}

module "vpc" {
  source     = "./modules/vpc"
  create_vpc = var.create_vpc
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
}

module "ecr" {
  source            = "./modules/ecr.tf"
  app_name          = var.app_name
  create_repository = var.create_ecr_repository
}

data "aws_route53_zone" "acm_lookup_by_id" {
  count   = local.use_hosted_zone_id ? 1 : 0
  zone_id = var.hosted_zone_id
}

data "aws_route53_zone" "acm_lookup_by_name" {
  count        = local.use_hosted_zone_id ? 0 : 1
  name         = trimspace(var.hosted_zone_name)
  private_zone = false
}

resource "aws_acm_certificate" "app_cert" {
  count             = local.use_existing_certificate ? 0 : 1
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = local.use_existing_certificate ? {} : {
    for dvo in aws_acm_certificate.app_cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = local.route53_validation_zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "app_cert_validation" {
  count                   = local.use_existing_certificate ? 0 : 1
  certificate_arn         = aws_acm_certificate.app_cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

module "alb" {
  source          = "./modules/alb"
  app_name        = var.app_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
  container_port  = var.container_port
  certificate_arn = local.validated_certificate_arn
}

resource "aws_security_group" "ecs_service" {
  name        = "${var.app_name}-ecs-sg"
  description = "Allow ALB to reach ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ecs" {
  source                = "./modules/ecs"
  app_name              = var.app_name
  image_url             = var.image_url
  container_port        = var.container_port
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_id     = aws_security_group.ecs_service.id
  target_group_arn      = module.alb.target_group_arn
  create_execution_role = var.create_ecs_execution_role
  create_cluster        = var.create_ecs_cluster
}

module "route53" {
  source           = "./modules/route53"
  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name
  hosted_zone_id   = var.hosted_zone_id
  alb_dns_name     = module.alb.alb_dns_name
  alb_zone_id      = module.alb.alb_zone_id
}

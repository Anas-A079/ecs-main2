module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source   = "./modules/ecr.tf"
  app_name = var.app_name
}

data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

module "alb" {
  source          = "./modules/alb"
  app_name        = var.app_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
  container_port  = var.container_port
  certificate_arn = aws_acm_certificate_validation.app_cert_validation.certificate_arn
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
  source            = "./modules/ecs"
  app_name          = var.app_name
  image_url         = var.image_url
  container_port    = var.container_port
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = aws_security_group.ecs_service.id
  target_group_arn  = module.alb.target_group_arn
}

module "route53" {
  source           = "./modules/route53"
  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name
  alb_dns_name     = module.alb.alb_dns_name
  alb_zone_id      = module.alb.alb_zone_id
}

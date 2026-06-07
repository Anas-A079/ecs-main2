module "vpc" {
  source     = "./modules/vpc"
  create_vpc = var.create_vpc
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
}

module "ecr" {
  source            = "./modules/ecr"
  app_name          = var.app_name
  create_repository = var.create_ecr_repository
}

module "alb" {
  source           = "./modules/alb"
  app_name         = var.app_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids
  container_port   = var.container_port
  certificate_arn  = var.certificate_arn
  domain_name      = var.domain_name
  hosted_zone_id   = var.hosted_zone_id
  hosted_zone_name = var.hosted_zone_name
}

module "ecs" {
  source                = "./modules/ecs"
  app_name              = var.app_name
  image_url             = var.image_url
  container_port        = var.container_port
  subnet_ids            = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn

  create_execution_role = var.create_ecs_execution_role
  create_cluster        = var.create_ecs_cluster
}

module "route53" {
  source = "./modules/route53"

  zone_name      = var.hosted_zone_name
  hosted_zone_id = var.hosted_zone_id
  create_zone    = false
  domain_name    = var.domain_name
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}
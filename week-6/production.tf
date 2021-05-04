resource "random_id" "random_id_prefix" {
  byte_length = 2
}
/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "networking" {
  source = "./modules/networking"

  region               = var.region
  key_name             = var.key_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones
}
module "db" {
  source = "./modules/db"
}

module "policy" {
  source = "./modules/policy"
}

module "ec2_instances" {
  source = "./modules/ec2_instances"
  
  region               = var.region
  key_name             = var.key_name
  public_subnets_id    = module.networking.public_subnets_id
  private_subnets_id   = module.networking.private_subnets_id
  vpc_id               = module.networking.vpc_id
  profile              = module.policy.profile
}

resource "aws_security_group" "elb_http" {
  name                 = "elb_http"
  description          = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id               = module.networking.vpc_id

  ingress {
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]
  }

  egress {
    from_port          = 0
    to_port            = 0
    protocol           = "-1"
    cidr_blocks        = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb-example"

  subnets         = [
    module.networking.public_subnets_id,
    module.networking.private_subnets_id
  ]
  security_groups = [
    aws_security_group.elb_http.id
  ]
  internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  number_of_instances   = 2
  instances             = module.ec2_instances.public_instances_ids

  cross_zone_load_balancing   = true
  idle_timeout                = 15
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC with public subnets
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_count = var.public_subnet_count
  name_prefix         = var.name_prefix

  tags = var.tags
}

# Security group for EC2 instances
module "security_group" {
  source = "./modules/security_group"

  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  description = "Security group for ${var.name_prefix} EC2 instances"
  allow_ssh   = true
  ssh_cidr    = var.ssh_cidr
  allow_http  = var.allow_http
  allow_https = var.allow_https

  tags = var.tags
}

# Key pair with private key stored in Secrets Manager
module "key_pair" {
  source = "./modules/key_pair"

  key_name                    = "${var.name_prefix}-key"
  secret_recovery_window_days = var.secret_recovery_window_days

  tags = var.tags
}

# S3 bucket
module "s3_bucket" {
  source = "./modules/s3"

  bucket_name        = var.s3_bucket_name
  versioning_enabled = var.s3_versioning_enabled

  tags = var.tags
}

# EC2 instances in public subnets
module "ec2_instances" {
  source = "./modules/ec2"

  instance_count      = 2
  ami_id              = var.ec2_ami_id
  instance_type       = var.ec2_instance_type
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.security_group.security_group_id]
  associate_public_ip = true
  key_name            = module.key_pair.key_name
  root_volume_size    = var.ec2_root_volume_size
  name_prefix         = var.name_prefix

  tags = var.tags
}

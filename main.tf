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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  instance_names = ["${var.name_prefix}-db", "${var.name_prefix}-app"]
  key_names      = ["${var.name_prefix}-db-key", "${var.name_prefix}-app-key"]
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

  vpc_id           = module.vpc.vpc_id
  name_prefix      = var.name_prefix
  description      = "Security group for ${var.name_prefix} EC2 instances"
  allow_ssh        = true
  ssh_cidr         = var.ssh_cidr
  allow_http       = var.allow_http
  allow_https      = var.allow_https
  allow_postgresql = true
  postgresql_cidr  = var.vpc_cidr

  tags = var.tags
}

# Key pairs with private keys stored in Secrets Manager (one per EC2 instance)
module "key_pair" {
  source = "./modules/key_pair"

  key_names                   = local.key_names
  secret_recovery_window_days = var.secret_recovery_window_days

  tags = var.tags
}

# Generate random password for PostgreSQL
resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}|:,.<>?"
}

# Store DB password in Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.name_prefix}-db-password"
  description             = "PostgreSQL password for chatbot_user on ${var.name_prefix}-db"
  recovery_window_in_days = var.secret_recovery_window_days

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-db-password"
    }
  )
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = "chatbot_user"
    password = random_password.db_password.result
    database = "saas_support"
    port     = 5432
  })
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

  instance_names      = local.instance_names
  ami_id              = var.ec2_ami_id
  instance_type       = var.ec2_instance_type
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.security_group.security_group_id]
  associate_public_ip = true
  key_names           = module.key_pair.key_names
  root_volume_size    = var.ec2_root_volume_size

  user_data_scripts = [
    # DB instance user_data - installs and configures PostgreSQL 16
    <<-EOF
    #!/bin/bash
    set -e
    exec > >(tee /var/log/user-data.log) 2>&1

    echo "Starting DB instance setup..."

    # Update system
    dnf update -y

    # Install PostgreSQL 16
    dnf install -y postgresql16-server postgresql16

    # Initialize database
    postgresql-setup --initdb

    # Start and enable PostgreSQL
    systemctl start postgresql
    systemctl enable postgresql

    # Create database and user
    sudo -u postgres psql -c "CREATE DATABASE saas_support;"
    sudo -u postgres psql -c "CREATE USER chatbot_user WITH PASSWORD '${random_password.db_password.result}';"
    sudo -u postgres psql -c "ALTER DATABASE saas_support OWNER TO chatbot_user;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE saas_support TO chatbot_user;"

    # Configure PostgreSQL for remote access
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
    echo "host    saas_support    chatbot_user    ${var.vpc_cidr}    md5" >> /var/lib/pgsql/data/pg_hba.conf

    # Restart PostgreSQL to apply changes
    systemctl restart postgresql

    echo "DB instance setup complete!"
    EOF
    ,
    # App instance - no user_data
    ""
  ]

  tags = var.tags
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "supabase-chatbot"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

# Security Group Variables
variable "ssh_cidr" {
  description = "CIDR block for SSH access (restrict in production)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allow_http" {
  description = "Allow HTTP traffic"
  type        = bool
  default     = true
}

variable "allow_https" {
  description = "Allow HTTPS traffic"
  type        = bool
  default     = true
}

# Key Pair Variables
variable "secret_recovery_window_days" {
  description = "Number of days before secret is permanently deleted"
  type        = number
  default     = 7
}

# S3 Variables
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_versioning_enabled" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

# EC2 Variables
variable "ec2_ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "ec2_root_volume_size" {
  description = "Root volume size in GB for EC2 instances"
  type        = number
  default     = 20
}

aws_region  = "us-east-1"
name_prefix = "supabase-chatbot-prod"

# VPC Configuration
vpc_cidr            = "10.1.0.0/16"
public_subnet_count = 2

# Security Group Configuration
ssh_cidr    = "0.0.0.0/0"  # Restrict to specific IPs in production
allow_http  = true
allow_https = true

# Key Pair Configuration
secret_recovery_window_days = 30

# S3 Configuration
s3_bucket_name        = "supabase-chatbot-frontend-prod"
s3_versioning_enabled = true

# EC2 Configuration
ec2_ami_id           = "ami-0c55b159cbfafe1f0"
ec2_instance_type    = "t3.small"
ec2_root_volume_size = 30

tags = {
  Environment = "prod"
  Project     = "supabase-ai-support-agent"
  ManagedBy   = "terraform"
}

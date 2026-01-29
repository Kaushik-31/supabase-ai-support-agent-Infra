# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}

# Key Pair Outputs
output "key_pair_name" {
  description = "Name of the key pair"
  value       = module.key_pair.key_name
}

output "private_key_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the private key"
  value       = module.key_pair.secret_arn
}

output "private_key_secret_name" {
  description = "Name of the Secrets Manager secret containing the private key"
  value       = module.key_pair.secret_name
}

# S3 Outputs
output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = module.s3_bucket.bucket_domain_name
}

# EC2 Outputs
output "ec2_instance_ids" {
  description = "List of EC2 instance IDs"
  value       = module.ec2_instances.instance_ids
}

output "ec2_private_ips" {
  description = "List of EC2 private IP addresses"
  value       = module.ec2_instances.private_ips
}

output "ec2_public_ips" {
  description = "List of EC2 public IP addresses"
  value       = module.ec2_instances.public_ips
}

# SSH Connection Info
output "ssh_connection_instructions" {
  description = "Instructions to connect to EC2 instances via SSH"
  value       = <<-EOT
    To retrieve your private key and connect to your EC2 instances:

    1. Get the private key from Secrets Manager:
       aws secretsmanager get-secret-value --secret-id ${module.key_pair.secret_name} --query 'SecretString' --output text | jq -r '.private_key' > ${module.key_pair.key_name}.pem

    2. Set correct permissions:
       chmod 400 ${module.key_pair.key_name}.pem

    3. Connect to your instances:
       ssh -i ${module.key_pair.key_name}.pem ec2-user@<public-ip>

    Public IPs: ${join(", ", module.ec2_instances.public_ips)}
  EOT
}

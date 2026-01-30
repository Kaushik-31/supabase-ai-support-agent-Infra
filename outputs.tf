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
output "key_pair_names" {
  description = "List of key pair names"
  value       = module.key_pair.key_names
}

output "private_key_secret_arns" {
  description = "List of Secrets Manager secret ARNs containing the private keys"
  value       = module.key_pair.secret_arns
}

output "private_key_secret_names" {
  description = "List of Secrets Manager secret names containing the private keys"
  value       = module.key_pair.secret_names
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
    Each EC2 instance has its own unique key pair stored in Secrets Manager.

    To connect to DB Instance (${local.instance_names[0]}):
      aws secretsmanager get-secret-value --secret-id ${module.key_pair.secret_names[0]} --query 'SecretString' --output text | jq -r '.private_key' > ${local.key_names[0]}.pem
      chmod 400 ${local.key_names[0]}.pem
      ssh -i ${local.key_names[0]}.pem ec2-user@${module.ec2_instances.public_ips[0]}

    To connect to App Instance (${local.instance_names[1]}):
      aws secretsmanager get-secret-value --secret-id ${module.key_pair.secret_names[1]} --query 'SecretString' --output text | jq -r '.private_key' > ${local.key_names[1]}.pem
      chmod 400 ${local.key_names[1]}.pem
      ssh -i ${local.key_names[1]}.pem ec2-user@${module.ec2_instances.public_ips[1]}
  EOT
}

output "key_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.this.key_name
}

output "key_pair_id" {
  description = "ID of the key pair"
  value       = aws_key_pair.this.key_pair_id
}

output "key_fingerprint" {
  description = "Fingerprint of the key pair"
  value       = aws_key_pair.this.fingerprint
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret containing the private key"
  value       = aws_secretsmanager_secret.private_key.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret containing the private key"
  value       = aws_secretsmanager_secret.private_key.name
}

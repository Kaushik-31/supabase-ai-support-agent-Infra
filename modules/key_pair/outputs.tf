output "key_names" {
  description = "List of key pair names"
  value       = aws_key_pair.this[*].key_name
}

output "key_pair_ids" {
  description = "List of key pair IDs"
  value       = aws_key_pair.this[*].key_pair_id
}

output "key_fingerprints" {
  description = "List of key pair fingerprints"
  value       = aws_key_pair.this[*].fingerprint
}

output "secret_arns" {
  description = "List of Secrets Manager secret ARNs containing the private keys"
  value       = aws_secretsmanager_secret.private_key[*].arn
}

output "secret_names" {
  description = "List of Secrets Manager secret names containing the private keys"
  value       = aws_secretsmanager_secret.private_key[*].name
}

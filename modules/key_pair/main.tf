resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = var.tags
}

resource "aws_secretsmanager_secret" "private_key" {
  name                    = "${var.key_name}-private-key"
  description             = "Private key for EC2 SSH access - ${var.key_name}"
  recovery_window_in_days = var.secret_recovery_window_days

  tags = merge(
    var.tags,
    {
      Name = "${var.key_name}-private-key"
    }
  )
}

resource "aws_secretsmanager_secret_version" "private_key" {
  secret_id = aws_secretsmanager_secret.private_key.id
  secret_string = jsonencode({
    private_key     = tls_private_key.this.private_key_pem
    public_key      = tls_private_key.this.public_key_openssh
    key_name        = aws_key_pair.this.key_name
    key_fingerprint = aws_key_pair.this.fingerprint
  })
}

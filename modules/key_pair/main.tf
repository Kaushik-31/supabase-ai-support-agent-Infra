resource "tls_private_key" "this" {
  count = length(var.key_names)

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count = length(var.key_names)

  key_name   = var.key_names[count.index]
  public_key = tls_private_key.this[count.index].public_key_openssh

  tags = merge(
    var.tags,
    {
      Name = var.key_names[count.index]
    }
  )
}

resource "aws_secretsmanager_secret" "private_key" {
  count = length(var.key_names)

  name                    = "${var.key_names[count.index]}-private-key"
  description             = "Private key for EC2 SSH access - ${var.key_names[count.index]}"
  recovery_window_in_days = var.secret_recovery_window_days

  tags = merge(
    var.tags,
    {
      Name = "${var.key_names[count.index]}-private-key"
    }
  )
}

resource "aws_secretsmanager_secret_version" "private_key" {
  count = length(var.key_names)

  secret_id = aws_secretsmanager_secret.private_key[count.index].id
  secret_string = jsonencode({
    private_key     = tls_private_key.this[count.index].private_key_pem
    public_key      = tls_private_key.this[count.index].public_key_openssh
    key_name        = aws_key_pair.this[count.index].key_name
    key_fingerprint = aws_key_pair.this[count.index].fingerprint
  })
}

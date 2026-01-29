resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  count = var.allow_ssh ? 1 : 0

  security_group_id = aws_security_group.this.id
  description       = "Allow SSH access"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.ssh_cidr

  tags = {
    Name = "SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  count = var.allow_http ? 1 : 0

  security_group_id = aws_security_group.this.id
  description       = "Allow HTTP access"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "HTTP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  count = var.allow_https ? 1 : 0

  security_group_id = aws_security_group.this.id
  description       = "Allow HTTPS access"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "HTTPS"
  }
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "All outbound"
  }
}

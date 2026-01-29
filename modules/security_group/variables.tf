variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for security group name"
  type        = string
  default     = "app"
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for EC2 instances"
}

variable "allow_ssh" {
  description = "Allow SSH access"
  type        = bool
  default     = true
}

variable "ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allow_http" {
  description = "Allow HTTP access"
  type        = bool
  default     = true
}

variable "allow_https" {
  description = "Allow HTTPS access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

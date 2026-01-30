variable "instance_names" {
  description = "List of names for the EC2 instances"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs where instances will be launched (distributed across subnets)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to instances"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Associate a public IP address with the instances"
  type        = bool
  default     = false
}

variable "key_names" {
  description = "List of SSH key pair names (one per instance)"
  type        = list(string)
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Tags to apply to the EC2 instances"
  type        = map(string)
  default     = {}
}

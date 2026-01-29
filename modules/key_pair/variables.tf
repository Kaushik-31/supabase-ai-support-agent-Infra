variable "key_name" {
  description = "Name for the key pair"
  type        = string
}

variable "secret_recovery_window_days" {
  description = "Number of days before secret is permanently deleted"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

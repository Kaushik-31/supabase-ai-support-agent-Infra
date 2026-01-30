variable "key_names" {
  description = "List of names for the key pairs"
  type        = list(string)
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

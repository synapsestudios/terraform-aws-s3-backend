variable "name_prefix" {
  type        = string
  description = "The name prefix to give the bucket where the statefile and lockfile will be stored (Must be 23 characters or less)"
}

variable "use_kms" {
  type        = bool
  description = "Whether to use KMS encryption or not"
  default     = false
}

variable "principal_arns" {
  type        = list(string)
  description = "List of ARNs granted administrative and data-plane access to the KMS key. Required (non-empty) when use_kms is true."
  default     = []

  validation {
    condition     = !var.use_kms || length(var.principal_arns) > 0
    error_message = "principal_arns must contain at least one ARN when use_kms is true."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default     = {}
}

variable "bucket_prefix" {
  type        = string
  description = "The name to give the bucket where the statefile will be stored (Must be 32 characters or less)"
}

variable "use_kms" {
  type        = bool
  description = "Whether to use KMS encryption or not"
  default     = false
}

variable "principal_arns" {
  type        = list(string)
  description = "List of ARNs to grant access to the KMS key (if use_kms is true)"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default     = {}
}

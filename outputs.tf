output "kms_key_id" {
  value       = aws_kms_key.this[0].key_id
  description = "The provisioned KMS key id"
}

output "s3_bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The name of the s3 terraform backend bucket"
}

output "kms_key_id" {
  value       = length(aws_kms_key.this) > 0 ? aws_kms_key.this[*].key_id : null
  description = "The provisioned KMS key id"
}

output "s3_bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The name of the s3 terraform backend bucket"
}

output "dynamo_table_name" {
  value       = aws_dynamodb_table.this.name
  description = "The name of the dynamoDB table"
}
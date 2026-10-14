resource "aws_s3_bucket" "this-logs" {
  bucket_prefix = "${var.name_prefix}-tf-state-logs"
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "this-logs" {
  bucket = aws_s3_bucket.this-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this-logs" {
  bucket = aws_s3_bucket.this-logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.use_kms ? aws_kms_key.this[0].arn : null
      sse_algorithm     = var.use_kms ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "this-logs" {
  bucket = aws_s3_bucket.this-logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.this-logs.arn,
          "${aws_s3_bucket.this-logs.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

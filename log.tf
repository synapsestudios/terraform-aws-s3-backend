resource "aws_s3_bucket" "this-logs" {
  bucket_prefix = "${var.bucket_prefix}-logs"
  region        = var.region

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "this-logs" {
  bucket = aws_s3_bucket.this-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "this-logs" {
  bucket = aws_s3_bucket.this-logs.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this-logs" {
  bucket = aws_s3_bucket.this-logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

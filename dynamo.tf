resource "aws_dynamodb_table" "this" {
  name         = aws_s3_bucket.this.bucket
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = var.tags

}

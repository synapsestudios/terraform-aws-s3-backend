mock_provider "aws" {}

variables {
  name_prefix = "test-prefix"
  tags = {
    Environment = "test"
  }
}

run "default_no_kms" {
  command = plan
}

run "with_kms" {
  command = apply

  variables {
    use_kms        = true
    principal_arns = ["arn:aws:iam::123456789012:role/operator"]
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"
    error_message = "When use_kms = true, the state bucket SSE configuration must use aws:kms"
  }

  assert {
    condition     = strcontains(aws_kms_key.this[0].policy, "kms:Decrypt")
    error_message = "KMS policy must grant kms:Decrypt so principals can read encrypted state"
  }

  assert {
    condition     = strcontains(aws_kms_key.this[0].policy, "kms:GenerateDataKey")
    error_message = "KMS policy must grant kms:GenerateDataKey so S3 can write encrypted state"
  }
}

run "kms_requires_principal_arns" {
  command = plan

  variables {
    use_kms        = true
    principal_arns = []
  }

  expect_failures = [
    var.principal_arns,
  ]
}

run "buckets_deny_requests_without_tls" {
  command = apply

  assert {
    condition = jsondecode(aws_s3_bucket_policy.this.policy).Statement == [{
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource  = [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]
      Condition = { Bool = { "aws:SecureTransport" = "false" } }
    }]
    error_message = "the state bucket policy must deny every s3 action on aws_s3_bucket.this.arn and its objects when aws:SecureTransport is false, and nothing else"
  }

  assert {
    condition     = aws_s3_bucket_policy.this.bucket == aws_s3_bucket.this.id
    error_message = "aws_s3_bucket_policy.this must attach to aws_s3_bucket.this"
  }

  assert {
    condition = jsondecode(aws_s3_bucket_policy.this-logs.policy).Statement == [{
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource  = [aws_s3_bucket.this-logs.arn, "${aws_s3_bucket.this-logs.arn}/*"]
      Condition = { Bool = { "aws:SecureTransport" = "false" } }
    }]
    error_message = "the logs bucket policy must deny every s3 action on aws_s3_bucket.this-logs.arn and its objects when aws:SecureTransport is false, and nothing else"
  }

  assert {
    condition     = aws_s3_bucket_policy.this-logs.bucket == aws_s3_bucket.this-logs.id
    error_message = "aws_s3_bucket_policy.this-logs must attach to aws_s3_bucket.this-logs"
  }
}

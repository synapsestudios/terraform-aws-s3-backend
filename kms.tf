data "aws_caller_identity" "current" {
  count = var.use_kms ? 1 : 0
}

locals {
  kms_policy = var.use_kms ? {
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnableAccountRootKMSAccess"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current[0].account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowOperatorsToAdministerAndUseKey"
        Effect    = "Allow"
        Principal = { AWS = var.principal_arns }
        Action = [
          "kms:Describe*",
          "kms:Get*",
          "kms:List*",
          "kms:Enable*",
          "kms:Disable*",
          "kms:Update*",
          "kms:Put*",
          "kms:Revoke*",
          "kms:CreateGrant",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
        ]
        Resource = "*"
      },
    ]
  } : null
}

resource "aws_kms_key" "this" {
  count = var.use_kms ? 1 : 0

  description = "Terraform Backend KMS Key"
  policy      = jsonencode(local.kms_policy)

  enable_key_rotation = true

  tags = var.tags
}

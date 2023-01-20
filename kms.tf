resource "aws_kms_key" "this" {
  count = var.use_kms ? 1 : 0

  description = "Terraform Backend KMS Key"
  policy      = data.aws_iam_policy_document.kms_policy

  enable_key_rotation = true

  tags = var.tags

}

data "aws_iam_policy_document" "kms_policy" {
  count = var.use_kms ? 1 : 0

  statement {
    sid = "Enable IAM User Permissions for KMS key"

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = var.principal_arns
    }
  }
}

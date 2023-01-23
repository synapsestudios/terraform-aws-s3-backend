# Terraform S3 Backend Module

Terraform module which creates S3 backend resources on AWS.

## Usage

### Example of usage that does not utilize KMS encryption:

_Non-KMS provisioning will default to AES256_

```hcl
module "s3_backend" {
  source = "github.com/synapsestudios/terraform-aws-s3-backend"

  bucket_prefix = "my-terraform-state"
  region = "us-west-2"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

### Example of usage utilizing KMS encryption:

:warning: **Enabling KMS requires a list of principal ARNs that will be granted access to the KMS key. All users added to this will have full access over the provisioned key** :warning:

```hcl
module "s3_backend" {
  source = "github.com/synapsestudios/terraform-aws-s3-backend"

  bucket_prefix = "my-terraform-state"
  region = "us-west-2"

  use_kms = true

  principal_arns = [
    "arn:aws:iam::123456789012:role/role-name",
    "arn:aws:iam::123456789012:role/role-name"
  ]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.this-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.this-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.this-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | The name to give the bucket where the statefile will be stored (Must be 32 characters or less) | `string` | n/a | yes |
| <a name="input_principal_arns"></a> [principal\_arns](#input\_principal\_arns) | List of ARNs to grant access to the KMS key (if use\_kms is true) | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region to place the resources in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_use_kms"></a> [use\_kms](#input\_use\_kms) | Whether to use KMS encryption or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The provisioned KMS key id |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the s3 terraform backend bucket |
<!-- END_TF_DOCS -->

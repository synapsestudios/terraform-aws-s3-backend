# Terraform S3 Backend Module

Terraform module which creates S3 backend resources on AWS.

State locking is handled by Terraform's native S3 lockfile mechanism (introduced in
Terraform 1.10), so no DynamoDB table is provisioned. Consumers configure locking
via `use_lockfile = true` on their `backend "s3"` block.

Requires Terraform `>= 1.10`.

## Usage

### Example of usage that does not utilize KMS encryption:

_Non-KMS provisioning will default to AES256_

```hcl
module "s3_backend" {
  source = "github.com/synapsestudios/terraform-aws-s3-backend"

  name_prefix = "my-tf-state"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

After applying, configure your backend to use the bucket with native S3 locking:

```hcl
terraform {
  backend "s3" {
    bucket       = "my-tf-state-tf-state-xxxxxxxx"
    key          = "path/to/your.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
```

### Example of usage utilizing KMS encryption:

:warning: **Enabling KMS requires a list of principal ARNs that will be granted access to the KMS key. All users added to this will have full access over the provisioned key** :warning:

```hcl
module "s3_backend" {
  source = "github.com/synapsestudios/terraform-aws-s3-backend"

  name_prefix = "my-tf-state"

  use_kms = true

  principal_arns = [
    "arn:aws:iam::123456789012:role/role-name",
    "arn:aws:iam::123456789012:role/role-name"
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Migrating from DynamoDB-based locking

Earlier versions of this module provisioned an `aws_dynamodb_table` and exposed
its name via the `dynamo_table_name` output to support the deprecated
`dynamodb_table` backend argument. Both have been removed.

To migrate an existing consumer:

1. Upgrade to this version of the module and `terraform apply`. The DynamoDB
   table will be destroyed once it is no longer referenced.
2. In every `backend "s3"` (and `terraform_remote_state`) block, replace
   `dynamodb_table = "..."` with `use_lockfile = true`.
3. Run `terraform init -reconfigure` against each affected root module so the
   backend picks up the new locking mechanism.

If you reference `module.s3_backend.dynamo_table_name` anywhere, remove those
references before upgrading.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.this-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
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
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix to give the bucket where the statefile and lockfile will be stored (Must be 23 characters or less) | `string` | n/a | yes |
| <a name="input_principal_arns"></a> [principal\_arns](#input\_principal\_arns) | List of ARNs to grant access to the KMS key (if use\_kms is true) | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_use_kms"></a> [use\_kms](#input\_use\_kms) | Whether to use KMS encryption or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The provisioned KMS key id |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the s3 terraform backend bucket |
<!-- END_TF_DOCS -->

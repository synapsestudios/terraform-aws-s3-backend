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
<!-- END_TF_DOCS -->

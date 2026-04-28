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

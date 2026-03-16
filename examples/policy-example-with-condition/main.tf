terraform {
  required_version = ">= 1.0"
}

resource "random_string" "unique" {
  length  = 8
  lower   = true
  upper   = false
  numeric = true
  special = false
}

module "storage_bucket_with_policy" {
  source = "../../"

  bucket_name   = "test-policy-bucket-${random_string.unique.result}"
  storage_roles = ["storage.admin", "storage.viewer"]

  policy = {
    enabled = true
    statements = [
      {
        sid       = "AllowReadSomeSources"
        effect    = "Allow"
        actions   = ["s3:GetObject"]
        resources = ["arn:aws:s3:::test-policy-bucket-${random_string.unique.result}/*"]
        principal = {
          type        = "*"
          identifiers = ["*"]
        }
        condition = [{
          type   = "StringEquals"
          key    = "s3:x-amz-content-sha256"
          values = ["test-sha"]
          }, {
          type   = "IpAddress"
          key    = "aws:sourceip"
          values = ["10.0.0.0/8"]
        }]
      }
    ]
  }

  policy_console = {
    enabled = true
    sid     = "ConsoleAccess"
    effect  = "Allow"
  }
}

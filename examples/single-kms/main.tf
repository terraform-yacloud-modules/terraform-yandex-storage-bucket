module "private_buckets" {
  source = "../../"

  bucket_name = "your-unique-bucket-name-kms"

  acl = "private"
  storage_roles = ["storage.admin", "storage.viewer"]

  server_side_encryption_configuration = {
    enabled       = true
    sse_algorithm = "aws:kms"
  }

  sse_kms_key_configuration = {
    name_prefix         = "sse-kms-key"
    description         = "KMS key for Object storage server-side encryption."
    default_algorithm   = "AES_256"
    rotation_period     = "8760h"
    deletion_protection = false
  }

  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }

}

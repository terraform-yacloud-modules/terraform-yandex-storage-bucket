terraform {
  required_version = ">= 1.0"
}

module "private_buckets" {
  source = "../../"

  # Naming
  bucket_name = "my-unique-private-bucket-name"

  storage_roles = ["storage.admin", "storage.viewer"]

  # Tags
  tags = {
    environment = "production"
    owner       = "admin"
  }

  # Storage options
  max_size      = 5368709120 # 5 GB
  force_destroy = false
  # acl                   = "private"  # DEPRECATED: Use grant instead
  grant                 = []
  default_storage_class = "STANDARD"
  anonymous_access_flags = {
    list        = false
    read        = false
    config_read = false
  }

  # Versioning
  versioning = {
    enabled = true
  }

}

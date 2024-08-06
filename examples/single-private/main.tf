module "private_buckets" {
  source = "../../"

  # Naming
  bucket_name = "my-unique-private-bucket-name"

  # Tags
  tags = {
    environment = "production"
    owner       = "admin"
  }

  # Storage options
  max_size = 5368709120  # 5 GB
  force_destroy = false
  acl = "private"
  grant = []
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

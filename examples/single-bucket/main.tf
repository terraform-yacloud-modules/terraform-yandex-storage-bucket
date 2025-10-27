terraform {
  required_version = ">= 1.0"
}

module "storage_buckets" {
  source = "../../"

  bucket_name   = "my-unique-bucket-name"
  storage_roles = ["storage.admin", "storage.viewer"]
}

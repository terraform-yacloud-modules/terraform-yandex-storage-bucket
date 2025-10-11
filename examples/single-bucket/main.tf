module "storage_buckets" {
  source = "../../"

  bucket_name = "my-unique-bucket-name"
  storage_roles = ["storage.admin", "storage.viewer"]
}

terraform {
  required_version = ">= 1.0"
}

module "storage_buckets" {
  for_each = {
    for k, v in var.buckets : k => v if v["enabled"]
  }

  source = "../../"

  bucket_name = format("my-unique-bucket-name-%s", each.key)

  storage_roles = ["storage.admin", "storage.viewer"]

  #   storage_class     = each.value["storage_class"]
  #   max_size          = each.value["max_size"]
  #   enable_versioning = each.value["enable_versioning"]
}

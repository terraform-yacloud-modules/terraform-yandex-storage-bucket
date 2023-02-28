resource "yandex_storage_bucket" "this" {
  access_key = var.access_key
  secret_key = var.secret_key

  bucket    = var.name
  folder_id = var.folder_id

  max_size              = var.max_size
  default_storage_class = var.storage_class
  force_destroy         = var.force_destroy

  dynamic "cors_rule" {
    for_each = var.cors_rule != null ? [1] : []
    content {
      allowed_headers = cors_rule.value["allowed_headers"]
      allowed_methods = cors_rule.value["allowed_methods"]
      allowed_origins = cors_rule.value["allowed_origins"]
      expose_headers  = cors_rule.value["expose_headers"]
      max_age_seconds = cors_rule.value["max_age_seconds"]
    }
  }

  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }

  #  logging {
  #    target_bucket = yandex_storage_bucket.log_bucket.id
  #    target_prefix = "tf-logs/"
  #  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.enable_server_side_encryption ? [1] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = var.server_side_encryption_kms_id
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }

  anonymous_access_flags {
    read = var.anonymous_access.read
    list = var.anonymous_access.list
  }

  dynamic "https" {
    for_each = var.http_certificate_id != null ? [1] : []
    content {
      certificate_id = var.http_certificate_id
    }
  }
}

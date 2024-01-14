locals {
  sse_kms_master_key_name = var.sse_kms_key_configuration.name_prefix != null ? "${var.sse_kms_key_configuration.name_prefix}-${random_string.unique_id.result}" : null
}

resource "yandex_kms_symmetric_key" "this" {
  count               = var.server_side_encryption_configuration.enabled && var.server_side_encryption_configuration.kms_master_key_id == null ? 1 : 0
  name                = try(coalesce(var.sse_kms_key_configuration.name, local.sse_kms_master_key_name), null)
  description         = var.sse_kms_key_configuration.description
  folder_id           = local.folder_id
  default_algorithm   = var.sse_kms_key_configuration.default_algorithm
  rotation_period     = var.sse_kms_key_configuration.rotation_period
  deletion_protection = var.sse_kms_key_configuration.deletion_protection
}

resource "yandex_resourcemanager_folder_iam_member" "kms_storage_admin_sa" {
  count     = var.server_side_encryption_configuration.enabled && var.storage_admin_service_account.existing_account_id == null ? 1 : 0
  folder_id = local.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.storage_admin[0].id}"
}

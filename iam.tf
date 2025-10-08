resource "yandex_iam_service_account" "storage_admin" {
  for_each = var.storage_admin_service_account.existing_account_id == null ? {
    create = true
  } : {}

  name        = coalesce(var.storage_admin_service_account.name, local.storage_admin_service_account_name)
  description = var.storage_admin_service_account.description
  folder_id   = local.folder_id
}

resource "yandex_iam_service_account_static_access_key" "storage_admin" {
  for_each = var.storage_admin_service_account.existing_account_id == null ? {
    create = true
  } : {}

  service_account_id = yandex_iam_service_account.storage_admin["create"].id
  description        = "Static access key for Object storage admin service account."
}

resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  for_each = var.storage_admin_service_account.existing_account_id == null ? {
    create = true
  } : {}

  folder_id = local.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage_admin["create"].id}"

  depends_on = [yandex_iam_service_account_static_access_key.storage_admin]
}

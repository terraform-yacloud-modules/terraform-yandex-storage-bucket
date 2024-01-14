data "yandex_client_config" "client" {}

data "yandex_iam_service_account" "existing_account" {
  count              = var.storage_admin_service_account.existing_account_id != null ? 1 : 0
  service_account_id = var.storage_admin_service_account.existing_account_id
}

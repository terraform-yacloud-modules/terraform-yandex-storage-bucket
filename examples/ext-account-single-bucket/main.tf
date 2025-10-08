module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account?ref=v1.0.0"

  name = "test-iam-accounts"
  folder_roles = [
    "storage.admin"
  ]
  enable_static_access_key = true
}


module "storage_buckets" {
  source = "../../"

  bucket_name = "my-unique-bucket-name"
  storage_admin_service_account = {
    existing_account_id         = module.iam_accounts.id
    existing_account_access_key = module.iam_accounts.sak_access_key
    existing_account_secret_key = module.iam_accounts.sak_secret_key
  }

  depends_on = [
    module.iam_accounts,
  ]

}

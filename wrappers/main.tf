module "wrapper" {
  source = "../"

  for_each = var.items

  folder_id                            = try(each.value.folder_id, var.defaults.folder_id, null)
  bucket_name                          = try(each.value.bucket_name, var.defaults.bucket_name, null)
  tags                                 = try(each.value.tags, var.defaults.tags, {})
  max_size                             = try(each.value.max_size, var.defaults.max_size, 5368709120)
  force_destroy                        = try(each.value.force_destroy, var.defaults.force_destroy, false)
  storage_admin_service_account        = try(each.value.storage_admin_service_account, var.defaults.storage_admin_service_account, {})
  acl                                  = try(each.value.acl, var.defaults.acl, null)
  grant                                = try(each.value.grant, var.defaults.grant, [])
  policy                               = try(each.value.policy, var.defaults.policy, { enabled = false })
  default_storage_class                = try(each.value.default_storage_class, var.defaults.default_storage_class, "STANDARD")
  anonymous_access_flags               = try(each.value.anonymous_access_flags, var.defaults.anonymous_access_flags, null)
  https                                = try(each.value.https, var.defaults.https, null)
  policy_console                       = try(each.value.policy_console, var.defaults.policy_console, { enabled = false })
  cors_rule                            = try(each.value.cors_rule, var.defaults.cors_rule, [])
  website                              = try(each.value.website, var.defaults.website, null)
  versioning                           = try(each.value.versioning, var.defaults.versioning, null)
  object_lock_configuration            = try(each.value.object_lock_configuration, var.defaults.object_lock_configuration, null)
  logging                              = try(each.value.logging, var.defaults.logging, null)
  lifecycle_rule                       = try(each.value.lifecycle_rule, var.defaults.lifecycle_rule, [])
  server_side_encryption_configuration = try(each.value.server_side_encryption_configuration, var.defaults.server_side_encryption_configuration, { enabled = false })
  sse_kms_key_configuration            = try(each.value.sse_kms_key_configuration, var.defaults.sse_kms_key_configuration, {})
  storage_roles                        = try(each.value.storage_roles, var.defaults.storage_roles, ["storage.admin"])
}

output "access_key" {
  description = "Access key for the storage admin"
  value       = module.storage_buckets.storage_admin_access_key
}

output "secret_key" {
  description = "Secret key for the storage admin"
  value       = module.storage_buckets.storage_admin_secret_key
  sensitive   = true
}

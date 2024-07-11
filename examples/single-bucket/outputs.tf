output "access_key" {
  value       = module.storage_buckets.storage_admin_access_key
}

output "secret_key" {
  value       = module.storage_buckets.storage_admin_secret_key
  sensitive = true
}

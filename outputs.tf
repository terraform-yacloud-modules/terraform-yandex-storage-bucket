output "id" {
  description = "Bucket Id"
  value       = yandex_storage_bucket.this.id
}

output "name" {
  description = "Bucket name"
  value       = yandex_storage_bucket.this.bucket
}

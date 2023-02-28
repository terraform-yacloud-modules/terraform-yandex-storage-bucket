#
# yandex cloud coordinates
#
variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = null
}

variable "access_key" {
  description = "The access key to use when applying changes. If omitted, storage_access_key specified in provider config is used"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "The secret key to use when applying changes. If omitted, storage_secret_key specified in provider config is used"
  type        = string
  default     = null
}

#
# naming
#
variable "name" {
  description = "Bucket name"
  type        = string
}

#
# storage options
#
variable "storage_class" {
  description = "Bucket storage class. Can be COLD or STANDARD"
  type        = string
  default     = "STANDARD"
}

variable "max_size" {
  description = "The size of bucket, in bytes (5 Gb by default). Set 0 if you do not want to limit bucket size"
  type        = number
  default     = 5368709120
}

variable "force_destroy" {
  description = "indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "cors_rule" {
  description = "Bucket CORS settings"
  type = object({
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  })
  default = null
}

variable "enable_versioning" {
  description = "If true, bucket versioning will be enabled"
  type        = bool
  default     = false
}

variable "enable_server_side_encryption" {
  description = "If true, server side encryption will be enabled"
  type        = bool
  default     = false
}

variable "server_side_encryption_kms_master_key_id" {
  description = "The KMS master key ID used for the SSE-KMS encryption"
  type        = string
  default     = null
}

variable "anonymous_access" {
  description = "Bucket anonymous access settings"
  type = object({
    read = optional(bool, false),
    list = optional(bool, false)
  })
  default = {}
}

variable "http_certificate_id" {
  description = "Id of the HTTPS certificate in Certificate Manager"
  type        = string
  default     = null
}

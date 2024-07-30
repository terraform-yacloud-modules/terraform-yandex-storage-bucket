variable "buckets" {
  description = "Map of buckets configuration"
  type = map(object({
    enabled           = bool
    storage_class     = string
    max_size          = number
    enable_versioning = bool
  }))
  default = {
    "data" = {
      enabled           = true
      storage_class     = "STANDARD"
      max_size          = 5368709120
      enable_versioning = false
    }
    "backup" = {
      enabled           = true
      storage_class     = "COLD"
      max_size          = 5368709120
      enable_versioning = false
    }
  }
}

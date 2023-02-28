variable "buckets" {
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

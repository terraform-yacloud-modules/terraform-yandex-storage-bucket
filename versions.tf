terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }

    random = {
      source  = "hashicorp/random"
    }

    aws = {
      source  = "hashicorp/aws"
    }
  }
}


resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

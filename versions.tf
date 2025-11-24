terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.72.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.22.1"
    }
  }
}

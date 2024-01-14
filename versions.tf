terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }

    random = {
      source = "hashicorp/random"
    }

    aws = {
      source = "hashicorp/aws"
    }
  }
}

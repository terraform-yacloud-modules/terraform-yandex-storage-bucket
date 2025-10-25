terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  # Фиктивные учетные данные для обхода проверки
  # Data source aws_iam Document не требует реальных учетных данных
  access_key                  = "dummy"
  secret_key                  = "dummy"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

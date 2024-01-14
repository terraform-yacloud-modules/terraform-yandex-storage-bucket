data "aws_iam_policy_document" "this" {
  count = var.policy.enabled || var.policy_console.enabled ? 1 : 0

  dynamic "statement" {
    for_each = var.policy.statements != null ? var.policy.statements : []
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = [
        for v in statement.value.resources :
        can(regex("arn:aws:s3:::.*", v)) ? v : format("arn:aws:s3:::%s", v)
      ]

      dynamic "principals" {
        for_each = statement.value.principal != null ? [
          statement.value.principal
        ] : []
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principal != null ? [
          statement.value.not_principal
        ] : []
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? [
          statement.value.condition
        ] : []
        content {
          test     = condition.value.type
          variable = condition.value.key
          values   = condition.value.values
        }
      }
    }
  }

  dynamic "statement" {
    for_each = range(var.policy_console.enabled ? 1 : 0)
    content {
      sid       = var.policy_console.sid
      effect    = var.policy_console.effect
      actions   = ["*"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*",
        "arn:aws:s3:::${var.bucket_name}"
      ]

      condition {
        test     = "StringLike"
        variable = "aws:referer"
        values   = [
          "https://console.cloud.yandex.*/folders/*/storage/buckets/${var.bucket_name}*"
        ]
      }

      dynamic "principals" {
        for_each = range(var.policy_console.principal == null && var.policy_console.not_principal == null ? 1 : 0)
        content {
          type        = "*"
          identifiers = ["*"]
        }
      }

      dynamic "principals" {
        for_each = range(var.policy_console.principal != null ? 1 : 0)
        content {
          type        = var.policy_console.principal.type
          identifiers = var.policy_console.principal.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = range(var.policy_console.not_principal != null ? 1 : 0)
        content {
          type        = var.policy_console.not_principal.type
          identifiers = var.policy_console.not_principal.identifiers
        }
      }
    }
  }

  dynamic "statement" {
    for_each = range(var.policy.enabled || var.policy_console.enabled ? 1 : 0)
    content {
      sid       = "default-rule-for-storage-admin-service-account"
      effect    = "Allow"
      actions   = ["*"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*",
        "arn:aws:s3:::${var.bucket_name}"
      ]

      dynamic "principals" {
        for_each = range(var.storage_admin_service_account.existing_account_id != null ? 1 : 0)
        content {
          type        = "CanonicalUser"
          identifiers = [var.storage_admin_service_account.existing_account_id]
        }
      }

      dynamic "principals" {
        for_each = range(var.storage_admin_service_account.existing_account_id == null ? 1 : 0)
        content {
          type        = "CanonicalUser"
          identifiers = [yandex_iam_service_account.storage_admin[0].id]
        }
      }
    }
  }
}

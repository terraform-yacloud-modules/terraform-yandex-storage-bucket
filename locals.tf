locals {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)

  cm_certificate_name                = try(var.https.certificate.name_prefix != null, false) ? "${var.https.certificate.name_prefix}-${random_string.unique_id.result}" : "s3-https-certificate-${random_string.unique_id.result}"
  sse_kms_master_key_name            = var.sse_kms_key_configuration.name_prefix != null ? "${var.sse_kms_key_configuration.name_prefix}-${random_string.unique_id.result}" : null
  storage_admin_service_account_name = var.storage_admin_service_account.name_prefix != null ? "${var.storage_admin_service_account.name_prefix}-${random_string.unique_id.result}" : "storage-admin-${random_string.unique_id.result}"

  routing_rules_dict = {
    condition                       = "Condition"
    redirect                        = "Redirect"
    key_prefix_equals               = "KeyPrefixEquals"
    http_error_code_returned_equals = "HttpErrorCodeReturnedEquals"
    protocol                        = "Protocol"
    host_name                       = "HostName"
    replace_key_prefix_with         = "ReplaceKeyPrefixWith"
    replace_key_with                = "ReplaceKeyWith"
    http_redirect_code              = "HttpRedirectCode"
  }

  # Change `routing_rules` json by converting keys from snake_case to PascalCase to match routing_rules schema.
  # https://cloud.yandex.com/en-ru/docs/storage/s3/api-ref/hosting/upload#request-params
  # Determine whether the `website` variable is set and whether can get a list of objects in `routing_rules`.
  # For each object in `routing_rules` recursively replace all attribute keys (including nested ones) with values from the `routing_rules_dict` dictionary.

  # Conversion result example:

  # From:
  #   routing_rules = [
  #     {
  #       condition = {
  #         key_prefix_equals = "docs/"
  #       },
  #       redirect = {
  #         replace_key_prefix_with = "documents/"
  #       }
  #     }
  #   ]

  # To:
  #   routing_rules = [
  #     {
  #       Condition = {
  #         KeyPrefixEquals = "docs/"
  #       },
  #       Redirect  = {
  #         ReplaceKeyPrefixWith = "documents/"
  #       }
  #     }
  #   ]
  routing_rules = try(var.website.routing_rules != null ? jsonencode([
    for rule in var.website.routing_rules : {
      for key, value in rule : lookup(local.routing_rules_dict, key, null) => {
        for k, v in value : lookup(local.routing_rules_dict, k, null) => v
        if v != null
      } if value != null && value != {}
    }
  ]) : null, null)
}

#
# yandex cloud coordinates
#
variable "folder_id" {
  description = <<EOF
    (Optional) The ID of the Yandex Cloud Folder that the resources belongs to.

    Allows to create bucket in different folder.
    It will try to create bucket using IAM-token in provider config, not using access_key.
    If omitted, folder_id specified in provider config and access_key is used.
  EOF
  type        = string
  default     = null
}

#
# naming
#
variable "bucket_name" {
  type        = string
  description = "(Required) The name of the bucket."
  validation {
    condition     = var.bucket_name != null
    error_message = "Bucket name is not set."
  }
  validation {
    condition     = !can(regex("[^A-Za-z-.0-9]", var.bucket_name))
    error_message = "The name of the bucket can contain only a-z, A-Z, \"-\", 0-9 and \".\""
  }
  default = null
}

variable "tags" {
  description = <<EOF
    (Optional) Object for setting tags (or labels) for bucket.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/tags.
  EOF
  type        = map(string)
  default     = {}
}

#
# storage options
#
variable "max_size" {
  description = <<EOF
    (Optional) The size of bucket, in bytes (5 Gb by default). Set 0 if you do not want to limit bucket size.
    For more information see https://cloud.yandex.com/en/docs/storage/operations/buckets/limit-max-volume.

    It will try to create bucket using IAM-token in provider block, not using access_key.
  EOF
  type        = number
  default     = 5368709120
}

variable "force_destroy" {
  description = "(Optional) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are NOT recoverable."
  type        = bool
  default     = false
}

variable "storage_admin_service_account" {
  description = <<EOF
    (Optional) Allows to manage storage admin service account for the bucket.

    Configuration attributes:
      name                        - (Optional) The name of the service account to be generated. Conflicts with `name_prefix` and `existing_account_id`.
      name_prefix                 - (Optional) Prefix of the service account name. A unique service account name will be generated using the prefix. Conflicts with `name` and `existing_account_id`.
      description                 - (Optional) Description of the service account to be generated.
      existing_account_id         - (Optional) Allows to specify an existing service account ID to manage the bucket. The service account must have `storage.admin` permissions in the folder. Conflicts with `name` and `name_prefix`.
      existing_account_access_key - (Optional) The access key of an existing service account to use when applying changes. If omitted, `storage_access_key` specified in provider config is used.
      existing_account_secret_key - (Optional) The secret key of an existing service account to use when applying changes. If omitted, `storage_secret_key` specified in provider config is used.

    By default, if the object is not set in the input variables of the module, a service account will be automatically generated with the name prefix `storage-admin`,
    an access key will be automatically generated with random name, and the role of `storage.admin` will be assigned to the generated service account.
  EOF
  nullable    = false
  type = object({
    name                        = optional(string)
    name_prefix                 = optional(string)
    description                 = optional(string, "Service account for Object storage admin.")
    existing_account_id         = optional(string)
    existing_account_access_key = optional(string)
    existing_account_secret_key = optional(string)
  })
  validation {
    condition     = !(var.storage_admin_service_account.name != null && var.storage_admin_service_account.name_prefix != null)
    error_message = "Attributes \"name\" and \"name_prefix\" conflicts. Only one of them should be used."
  }
  validation {
    condition     = !(var.storage_admin_service_account.name != null && var.storage_admin_service_account.existing_account_id != null)
    error_message = "Attributes \"name\" and \"existing_account_id\" conflicts. Only one of them should be used."
  }
  validation {
    condition     = !(var.storage_admin_service_account.name_prefix != null && var.storage_admin_service_account.existing_account_id != null)
    error_message = "Attributes \"name_prefix\" and \"existing_account_id\" conflicts. Only one of them should be used."
  }
  validation {
    condition     = !(var.storage_admin_service_account.existing_account_id == null && var.storage_admin_service_account.existing_account_access_key != null)
    error_message = "Cannot use attribute \"existing_account_access_key\" when attribute \"existing_account_id\" is not set."
  }
  validation {
    condition     = !(var.storage_admin_service_account.existing_account_id == null && var.storage_admin_service_account.existing_account_secret_key != null)
    error_message = "Cannot use attribute \"existing_account_secret_key\" when attribute \"existing_account_id\" is not set."
  }
  default = {}
}

variable "storage_roles" {
  description = "Список ролей, которые будут назначены сервисному аккаунту для управления хранилищем"
  type        = list(string)
  default     = ["storage.admin"]
}

variable "acl" {
  description = <<EOF
    (Optional) [DEPRECATED] The predefined ACL to apply. Defaults to `private`. Conflicts with `grant` object.
    To change ACL after creation, service account with `storage.admin` role should be used, though this role is not necessary to create a bucket with any ACL.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/acl#predefined-acls.
    
    WARNING: This parameter is deprecated. Use `grant` object with `yandex_storage_bucket_grant` instead.
  EOF
  type        = string
  default     = null
}

variable "grant" {
  description = <<EOF
    (Optional) List of objects for an ACL policy grant. Conflicts with `acl` variable.
    To manage grant argument, service account with `storage.admin` role should be used.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/acl#permissions-types.

    Configuration attributes:
      id          - (Optional) Permission recipient ID.
      type        - (Required) Permission recipient type.
      uri         - (Optional) System group URI.
      permissions - (Required) List of assigned permissions.
  EOF
  nullable    = false
  type = list(object({
    id          = optional(string)
    type        = string
    uri         = optional(string)
    permissions = set(string)
  }))
  default = []
}

variable "policy" {
  description = <<EOF
    (Optional) [DEPRECATED] Object storage policy.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/policy.

    WARNING: This parameter is deprecated. Use `yandex_storage_bucket_policy` resource instead.
    NOTE: Bucket policy for Yandex Cloud Console is defined in a separate `policy_console` variable.

    Configuration attributes:
      enabled    - (Required) Enable policy.
      id         - (Optional) General information about the policy. Some Yandex Cloud services require the uniqueness of this value.
      version    - (Optional) Access policy description version. Possible values is `2012-10-17`.
      statements - (Optional) List of bucket policy rules.

    Objects in the `statements` supports the following attributes:
      sid           - (Optional) Rule ID.
      effect        - (Optional) Specifies whether the requested action is denied or allowed. Possible values: `Allow`, `Deny`. Defaults to `Allow`.
      actions       - (Required) Determines the action to be executed when the policy is triggered.
      resources     - (Required) Specifies the list of the resources that the action will be performed on. Prefix `arn:aws:s3:::` can be omitted from resource names.
      principal     - (Optional) ID of the recipient of the requested permission.
      not_principal - (Optional) ID of the entity that will not receive the requested permission.
      condition     - (Optional) Condition that will be checked.

    The `principal` object supports the following attributes:
      type        - (Required) Type of the entity. Possible values: `*`, `CanonicalUser`.
      identifiers - (Required) List of IDs.

    The `not_principal` object supports the following attributes:
      type        - (Required) Type of the entity. Possible value is `CanonicalUser`.
      identifiers - (Required) List of IDs.

    The `condition` object supports the following attributes:
      type   - (Required) Condition type.
      key    - (Required) Specifies the condition whose value will be checked.
      values - (Required) List of values.
  EOF
  nullable    = false
  type = object({
    enabled = bool
    statements = optional(list(object({
      sid       = optional(string)
      effect    = optional(string)
      actions   = list(string)
      resources = list(string)
      principal = optional(object({
        type        = string
        identifiers = list(string)
      }))
      not_principal = optional(object({
        type        = string
        identifiers = list(string)
      }))
      condition = optional(object({
        type   = string
        key    = string
        values = list(any)
      }))
    })))
  })
  validation {
    condition     = try((length(var.policy.statements) != 0), true)
    error_message = "Policy \"statements\" cannot be empty list."
  }

  # Explanation of the conditions below.

  # First, determine whether the `policy` is set and whether can get a list of objects in `statements`:
  #   try(coalesce(var.policy.statements, []), [])
  # Here:
  #   - if `var.policy.statements` does not exist because no policy is set (var.policy = null),
  # then the `coalesce` function will return an error, which will be handled by the `try` function and return an empty list as a fallback.
  #   - if `var.policy.statements` is null, assume that the variable does not have a valid value.
  # The `coalesce` function will skip the value and return an empty list as a fallback.
  #   - in other cases, a list of objects in `statements` will be returned.

  # Then, for each object in the list of `statements`, check the values of `principal` and `not_principal`.
  # If both are not set then return true. Collect all the results in a list for checking by the `anytrue` function.
  # If at least one object returns true, then consider the condition not fulfilled.
  validation {
    condition = !(anytrue([
      for k in try(coalesce(var.policy.statements, []), []) :
      k.principal == null && k.not_principal == null
    ]))
    error_message = "One of \"principal\" or \"not_principal\" should be specified in every \"statement\"."
  }

  # For each object in the list of `statements`, check that both `principal` and `not_principal` are not set at the same time.
  # If both are not set then return true. Collect all the results in a list for checking by the `anytrue` function.
  # If at least one object returns true, then consider the condition not fulfilled.
  validation {
    condition = !(anytrue([
      for k in try(coalesce(var.policy.statements, []), []) :
      k.principal != null && k.not_principal != null
    ]))
    error_message = "Attributes \"principal\" and \"not_principal\" conflicts. Only one of them should be used in every \"statement\"."
  }

  # For each object in the list of `statements`, validate the value of `principal`, if it is set.
  # Collect all the results in a list for checking by the `alltrue` function.
  # If at least one object returns false, then consider the condition not fulfilled.
  validation {
    condition = alltrue([
      for k in try(coalesce(var.policy.statements, []), []) :
      contains(["*", "CanonicalUser"], k.principal.type) if k.principal != null
    ])
    error_message = "Principal type valid value is \"*\" or \"CanonicalUser\"."
  }

  # For each object in the list of `statements`, validate the value of `not_principal`, if it is set.
  # Collect all the results in a list for checking by the `alltrue` function.
  # If at least one object returns false, then consider the condition not fulfilled.
  validation {
    condition = alltrue([
      for k in try(coalesce(var.policy.statements, []), []) :
      contains(["CanonicalUser"], k.not_principal.type)
      if k.not_principal != null
    ])
    error_message = "NotPrincipal type valid value is \"CanonicalUser\"."
  }

  # For each object in the `statements` list, validate the values of the `condition` object.
  # For the `type` and `key` attributes, check for a match with specific values.
  # The `values` attribute is a list, each value of which is checked for a match by a regular expression. If at least one element matches, then return true.
  # Finally, collect all the results of validation of the `condition` objects into a list for checking by the `anytrue` function.
  # If at least one object returns true, then we consider the condition not fulfilled.
  validation {
    condition = !(anytrue([
      for k in try(coalesce(var.policy.statements, []), []) :
      try(k.condition.type == "StringLike", false) &&
      try(k.condition.key == "aws:referer", false) &&
      try(k.condition.values != null ? anytrue([
        for item in k.condition.values :
        can(regex("^https?://console.cloud.yandex", item))
        ]) : false,
      false)
    ]))
    error_message = "Policy rule for Yandex Cloud Console should be specified in \"policy_console\" variable."
  }
  default = {
    enabled = false
  }
}


variable "default_storage_class" {
  description = <<EOF
    (Optional) Storage class which is used for storing objects by default.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/storage-class.

    Available values are: `STANDARD`, `COLD`, `ICE`. Default is `STANDARD`.
    It will try to create bucket using IAM-token in provider block, not using access_key.
  EOF
  type        = string
  validation {
    condition = contains([
      "STANDARD", "COLD", "ICE"
    ], var.default_storage_class)
    error_message = "Available values are \"STANDARD\", \"COLD\" and \"ICE\" (case sensitive)."
  }
  default = "STANDARD"
}

variable "anonymous_access_flags" {
  description = <<EOF
    (Optional) Object provides various access to objects.
    For more information see https://cloud.yandex.com/en/docs/storage/operations/buckets/bucket-availability.

    Configuration attributes:
      list        - (Optional) Allows to read objects in bucket anonymously.
      read        - (Optional) Allows to list object in bucket anonymously.
      config_read - (Optional) Allows to list bucket configuration anonymously.

    It will try to create bucket using IAM-token in provider config, not using access_key.
  EOF
  type = object({
    list        = optional(bool)
    read        = optional(bool)
    config_read = optional(bool)
  })
  default = null
}

variable "https" {
  description = <<EOF
    (Optional) Object manages https certificate for bucket.
    For more information see https://cloud.yandex.com/en/docs/storage/operations/hosting/certificate.

    At least one of `certificate`, `existing_certificate_id` must be specified.

    Configuration attributes:
      existing_certificate_id - (Optional) Id of an existing certificate in Yandex Cloud Certificate Manager, that will be used for the bucket.
      certificate             - (Optional) Object allows to manage the parameters for generating a managed HTTPS certificate in Yandex Cloud Certificate Manager.

    The `certificate` object supports the following attributes:
      domains             - (Required) Domains for this certificate.
      public_dns_zone_id  - (Required) The id of the DNS zone in which record set will reside.
      dns_records_ttl     - (Optional) The time-to-live of DNS record set (seconds). Default value is `300`.
      name                - (Optional) Certificate name. Conflicts with `name_prefix`.
      name_prefix         - (Optional) Prefix of the certificate name. A unique certificate name will be generated using the prefix. Default value is `s3-https-certificate`. Conflicts with `name`.
      description         - (Optional) Certificate description.
      labels              - (Optional) Labels to assign to certificate.
      deletion_protection - (Optional) Prevents certificate deletion. Be aware that if the value is `true`, you will have to manually turn off deletion protection before removing the resource.

    It will try to create bucket using IAM-token in provider config, not using access_key.
  EOF
  type = object({
    existing_certificate_id = optional(string)
    certificate = optional(object({
      domains             = set(string)
      public_dns_zone_id  = string
      dns_records_ttl     = optional(number, 300)
      name                = optional(string)
      name_prefix         = optional(string)
      description         = optional(string, "Certificate for S3 static website.")
      labels              = optional(map(string))
      deletion_protection = optional(bool, true)
    }))
  })
  validation {
    condition     = !(try(var.https.certificate == null, false) && try(var.https.existing_certificate_id == null, false))
    error_message = "One of \"certificate\" or \"existing_certificate_id\" is required."
  }
  validation {
    condition     = !(try(var.https.certificate != null, false) && try(var.https.existing_certificate_id != null, false))
    error_message = "Attributes \"certificate\" and \"existing_certificate_id\" conflicts. Only one of them should be used."
  }
  validation {
    condition     = !(try(var.https.certificate.name != null, false) && try(var.https.certificate.name_prefix != null, false))
    error_message = "Certificate attributes \"name\" and \"name_prefix\" conflicts. Only one of them should be used."
  }
  default = null
}

variable "policy_console" {
  description = <<EOF
    (Optional) Object storage policy for Yandex Cloud Console (Web UI).
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/policy#console-access.

    Configuration attributes:
      enabled       - (Required) Enable policy for Yandex Cloud Console.
      sid           - (Optional) Rule ID.
      effect        - (Optional) Specifies whether the requested action is denied or allowed. Possible values: `Allow`, `Deny`. Defaults to `Allow`.
      principal     - (Optional) ID of the recipient of the requested permission.
      not_principal - (Optional) ID of the entity that will not receive the requested permission.

    The `principal` object supports the following attributes:
      type        - (Required) Type of the entity. Possible values: `*`, `CanonicalUser`.
      identifiers - (Required) List of IDs.

    The `not_principal` object supports the following attributes:
      type        - (Required) Type of the entity. Possible value is `CanonicalUser`.
      identifiers - (Required) List of IDs.
  EOF
  nullable    = false
  type = object({
    enabled = bool
    sid     = optional(string)
    effect  = optional(string)
    principal = optional(object({
      type        = string
      identifiers = list(string)
    }))
    not_principal = optional(object({
      type        = string
      identifiers = list(string)
    }))
  })
  validation {
    condition     = !(var.policy_console.principal != null && var.policy_console.not_principal != null)
    error_message = "Attributes \"principal\" and \"not_principal\" conflicts. Only one of them should be used."
  }
  validation {
    condition = try(contains([
      "*", "CanonicalUser"
    ], var.policy_console.principal.type), true)
    error_message = "Principal type valid value is \"*\" or \"CanonicalUser\"."
  }
  validation {
    condition = try(contains([
      "CanonicalUser"
    ], var.policy_console.not_principal.type), true)
    error_message = "NotPrincipal type valid value is \"CanonicalUser\"."
  }
  default = {
    enabled = false
  }
}

variable "cors_rule" {
  description = <<EOF
    (Optional) List of objets containing rules for Cross-Origin Resource Sharing.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/cors.

    Configuration attributes:
      allowed_headers - (Optional) Specifies which headers are allowed.
      allowed_methods - (Required) Specifies which methods are allowed. Can be `GET`, `PUT`, `POST`, `DELETE` or `HEAD` (case sensitive).
      allowed_origins - (Required) Specifies which origins are allowed.
      expose_headers  - (Optional) Specifies expose header in the response.
      max_age_seconds - (Optional) Specifies time in seconds that browser can cache the response for a preflight request.
  EOF
  nullable    = false
  type = list(object({
    allowed_headers = optional(set(string))
    allowed_methods = set(string)
    allowed_origins = set(string)
    expose_headers  = optional(set(string))
    max_age_seconds = optional(number)
  }))
  validation {
    condition = alltrue([
      for k in var.cors_rule : (
        length(setsubtract(k.allowed_methods, [
          "GET", "PUT", "POST", "DELETE", "HEAD"
        ])) == 0
      )
    ])
    error_message = "CORS \"allowed_methods\" can be GET, PUT, POST, DELETE or HEAD (case sensitive)."
  }
  default = []
}

variable "website" {
  description = <<EOF
    (Optional) Object for static web-site hosting or redirect configuration.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/hosting.

    Configuration attributes:
      index_document           - (Required, unless using redirect_all_requests_to) Storage returns this index document when requests are made to the root domain or any of the subfolders.
      error_document           - (Optional) An absolute path to the document to return in case of a 4XX error.
      routing_rules            - (Optional) List of json arrays containing routing rules describing redirect behavior and when redirects are applied. For more information see https://cloud.yandex.com/en/docs/storage/s3/api-ref/hosting/upload#request-scheme.
      redirect_all_requests_to - (Optional) A hostname to redirect all website requests for this bucket to. Hostname can optionally be prefixed with a protocol (http:// or https://) to use when redirecting requests. The default is the protocol that is used in the original request. When set, other website configuration attributes will be skiped.

    The `routing_rules` object supports the following attributes:
      condition - (Optional) Object used for conditions that trigger the redirect. If a routing rule doesn't contain any conditions, all the requests are redirected.
      redirect  - (Required) Object for configure redirect a request to a different page, different host, or change the protocol.

    The `condition` object supports the following attributes:
      key_prefix_equals               - (Optional) Sets the name prefix for the request-originating object.
      http_error_code_returned_equals - (Optional) Specifies the error code that triggers a redirect.

    The `redirect` object supports the following attributes:
      protocol                - (Optional) In the Location response header, a redirect indicates the protocol scheme (http or https) to be used.
      host_name               - (Optional) In the Location response header, a redirect indicates the host name to be used.
      replace_key_prefix_with - (Optional) Specifies the name prefix of the object key replacing `key_prefix_equals` in the redirect request. Incompatible with `replace_key_with`.
      replace_key_with        - (Optional) Specifies the object key to be used in the Location header. Incompatible with `replace_key_prefix_with`.
      http_redirect_code      - (Optional) In the Location response header, a redirect specifies the HTTP redirect code. Possible values: any 3xx code.

    The default value for index_document is used in case, when a website object is specified in the module input variables,
    but the index_document or redirect_all_requests_to are not set.
  EOF
  type = object({
    index_document = optional(string, "index.html")
    error_document = optional(string)
    routing_rules = optional(list(object({
      condition = optional(object({
        key_prefix_equals               = optional(string)
        http_error_code_returned_equals = optional(string)
      }))
      redirect = object({
        protocol                = optional(string)
        host_name               = optional(string)
        replace_key_prefix_with = optional(string)
        replace_key_with        = optional(string)
        http_redirect_code      = optional(string)
      })
    })))
    redirect_all_requests_to = optional(string)
  })

  validation {
    condition     = try((length(var.website.routing_rules) != 0), true)
    error_message = "Website \"routing_rules\" cannot be empty list."
  }

  # Explanation of the conditions below.

  # First, determine whether the `website` is set and whether can get a list of objects in `routing_rules`:
  #   try(coalesce(var.website.routing_rules, []), [])
  # Here:
  #   - if `var.website.routing_rules` does not exist because no policy is set (var.website = null),
  # then the `coalesce` function will return an error, which will be handled by the `try` function and return an empty list as a fallback.
  #   - if `var.website.routing_rules` is null, assume that the variable does not have a valid value.
  # The `coalesce` function will skip the value and return an empty list as a fallback.
  #   - in other cases, a list of objects in `routing_rules` will be returned.

  # Then, for each object in the list of `routing_rules`, check the values of `replace_key_with` and `replace_key_prefix_with`.
  # If both are set at the same time then return true. Collect all the results in a list for checking by the `anytrue` function.
  # If at least one object returns true, then consider the condition not fulfilled.
  validation {
    condition = !(anytrue([
      for k in try(coalesce(var.website.routing_rules, []), []) :
      k.redirect.replace_key_prefix_with != null && k.redirect.replace_key_with != null
    ]))
    error_message = "Attributes \"replace_key_prefix_with\" and \"replace_key_with\" conflicts. Only one of them should be used in each \"redirect\" rule."
  }

  # For each object in the list of `routing_rules`, validate the value of `redirect.protocol`, if it is set.
  # Collect all the results in a list for checking by the `alltrue` function.
  # If at least one object returns false, then consider the condition not fulfilled.
  validation {
    condition = alltrue([
      for k in try(coalesce(var.website.routing_rules, []), []) :
      contains(["http", "https"], k.redirect.protocol)
      if k.redirect.protocol != null
    ])
    error_message = "Website redirect \"protocol\" valid value is \"http\" or \"https\"."
  }

  # For each object in the list of `routing_rules`, validate the value of `redirect.http_redirect_code`, if it is set.
  # Collect all the results in a list for checking by the `alltrue` function.
  # If at least one object returns false, then consider the condition not fulfilled.
  validation {
    condition = alltrue([
      for k in try(coalesce(var.website.routing_rules, []), []) :
      can(regex("^30[0-8]$", k.redirect.http_redirect_code))
      if k.redirect.http_redirect_code != null
    ])
    error_message = <<EOF
      Only valid 3xx Redirection code are allowed in "http_redirect_code".
For more information see https://en.wikipedia.org/wiki/List_of_HTTP_status_codes.
EOF
  }
  default = null
}

variable "versioning" {
  description = <<EOF
    (Optional) Enable versioning.
    Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. Disabled by default.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/versioning.

    Configuration attributes:
      enabled - (Required) Enable versioning.
  EOF
  type = object({
    enabled = bool
  })
  default = null
}

variable "object_lock_configuration" {
  description = <<EOF
    (Optional) Configuration of object lock management.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/object-lock.

    Configuration attributes:
      object_lock_enabled - (Optional) Enable object locking in a bucket. Require versioning to be enabled.
      rule                - (Optional) Specifies a default locking configuration for added objects. Require object_lock_enabled to be enabled.

    The `rule` object consists of a nested `default_retention` object, which in turn supports the following attributes:
      mode  - (Required) Specifies a type of object lock. One of `GOVERNANCE` or `COMPLIANCE` (case sensitive).
      days  - (Optional) Specifies a retention period in days after uploading an object version. It must be a positive integer. You can't set it simultaneously with years.
      years - (Optional) Specifies a retention period in years after uploading an object version. It must be a positive integer. You can't set it simultaneously with days.
  EOF
  type = object({
    object_lock_enabled = optional(string, "Enabled")
    rule = optional(object({
      default_retention = object({
        mode  = string
        days  = optional(number)
        years = optional(number)
      })
    }))
  })
  default = null
}

variable "logging" {
  description = <<EOF
    (Optional) Configuration of bucket logging.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/server-logs.

    Configuration attributes:
      target_bucket - (Required) The name of the bucket that will receive the log objects.
      target_prefix - (Optional) To specify a key prefix for log objects.
  EOF
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = null
}

variable "lifecycle_rule" {
  description = <<EOF
    (Optional) List of objects with configuration of object lifecycle management.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/lifecycles.

    Configuration attributes:
      enabled                                - (Required) Specifies lifecycle rule status.
      id                                     - (Optional) Unique identifier for the rule. Must be less than or equal to 255 characters in length.
      prefix                                 - (Optional) Object key prefix identifying one or more objects to which the rule applies.
      abort_incomplete_multipart_upload_days - (Optional) Specifies the number of days after initiating a multipart upload when the multipart upload must be completed.
      expiration                             - (Optional) Specifies a period in the object's expire.
      transition                             - (Optional) Specifies a period in the object's transitions.
      noncurrent_version_expiration          - (Optional) Specifies when noncurrent object versions expire.
      noncurrent_version_transition          - (Optional) Specifies when noncurrent object versions transitions.

    At least one of `abort_incomplete_multipart_upload_days`, `expiration`, `transition`, `noncurrent_version_expiration`, `noncurrent_version_transition` must be specified.

    The `expiration` object supports the following attributes:
      date                         - (Optional) Specifies the date after which you want the corresponding action to take effect.
      days                         - (Optional) Specifies the number of days after object creation when the specific rule action takes effect.
      expired_object_delete_marker - (Optional) On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Object Storage to delete expired object delete markers.

    The `transition` object supports the following attributes:
      date          - (Optional) Specifies the date after which you want the corresponding action to take effect.
      days          - (Optional) Specifies the number of days after object creation when the specific rule action takes effect.
      storage_class - (Required) Specifies the storage class to which you want the object to transition. Can only be `COLD` or `STANDARD_IA`.

    The `noncurrent_version_expiration` object supports the following attributes:
      days - (Required) Specifies the number of days noncurrent object versions expire.

    The `noncurrent_version_transition` object supports the following attributes:
      days          - (Required) Specifies the number of days noncurrent object versions transition.
      storage_class - (Required) Specifies the storage class to which you want the noncurrent object versions to transition. Can only be `COLD` or `STANDARD_IA`.
  EOF
  nullable    = false
  type = list(object({
    enabled                                = bool
    id                                     = optional(string)
    prefix                                 = optional(string)
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    transition = optional(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    }))
    noncurrent_version_expiration = optional(object({
      days = number
    }))
    noncurrent_version_transition = optional(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
}

variable "server_side_encryption_configuration" {
  description = <<EOF
    (Optional) Object with configuration of server-side encryption for the bucket.
    For more information see https://cloud.yandex.com/en/docs/storage/concepts/encryption.

    Configuration attributes:
      enabled           - (Required) Enable server-side encryption for the bucket.
      sse_algorithm     - (Required) The server-side encryption algorithm to use. Single valid value is `aws:kms`.
      kms_master_key_id - (Optional) The KMS master key ID used for the server-side encryption. Allows to specify an existing KMS key for the server-side encryption. If omitted, the KMS key will be generated with parameters in the `sse_kms_key_configuration` variable.
  EOF
  nullable    = false
  type = object({
    enabled           = bool
    sse_algorithm     = optional(string, "aws:kms")
    kms_master_key_id = optional(string)
  })
  validation {
    condition = contains([
      "aws:kms"
    ], var.server_side_encryption_configuration.sse_algorithm)
    error_message = "\"sse_algorithm\" valid value is only \"aws:kms\" (case sensitive)."
  }
  default = {
    enabled = false
  }
}

variable "sse_kms_key_configuration" {
  description = <<EOF
    (Optional) Object with a KMS key configuration.
    For more information see https://cloud.yandex.com/en/docs/kms/concepts.

    Only used for an auto-generated KMS key.
    Will be ignored, if attribute `kms_master_key_id` is set in variable `server_side_encryption_configuration`.

    Configuration attributes:
      name                - (Optional) Name of the key. If omitted, Terraform will assign a random, unique name. Conflicts with `name_prefix`.
      name_prefix         - (Optional) Prefix of the key name. A unique KMS key name will be generated using the prefix. Conflicts with `name`.
      description         - (Optional) Description of the key.
      default_algorithm   - (Optional) Encryption algorithm to be used with a new key version, generated with the next rotation. Default value is `AES_256`.
      rotation_period     - (Optional) Interval between automatic rotations. To disable automatic rotation, omit this parameter. Default value is `8760h` (1 year).
      deletion_protection - (Optional) Prevents key deletion. Default value is `true`.
  EOF
  nullable    = false
  type = object({
    create_kms          = optional(bool, false)
    name                = optional(string)
    name_prefix         = optional(string)
    description         = optional(string, "KMS key for Object storage server-side encryption.")
    default_algorithm   = optional(string, "AES_256")
    rotation_period     = optional(string, "8760h")
    deletion_protection = optional(bool, true)
  })
  validation {
    condition     = !(var.sse_kms_key_configuration.name != null && var.sse_kms_key_configuration.name_prefix != null)
    error_message = "Attributes \"name\" and \"name_prefix\" conflicts. Only one should be used."
  }
  default = {}
}

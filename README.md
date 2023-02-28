# Yandex Cloud Storage Bucket Terraform module

Terraform module which creates Yandex Cloud storage bucket resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-storage-bucket/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_storage_bucket.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | The access key to use when applying changes. If omitted, storage\_access\_key specified in provider config is used | `string` | `null` | no |
| <a name="input_anonymous_access"></a> [anonymous\_access](#input\_anonymous\_access) | n/a | <pre>object({<br>    read = optional(bool, false),<br>    list = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | n/a | <pre>object({<br>    allowed_headers = optional(list(string))<br>    allowed_methods = optional(list(string))<br>    allowed_origins = optional(list(string))<br>    expose_headers  = optional(list(string))<br>    max_age_seconds = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_enable_server_side_encryption"></a> [enable\_server\_side\_encryption](#input\_enable\_server\_side\_encryption) | n/a | `bool` | `false` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | n/a | `bool` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| <a name="input_http_certificate_id"></a> [http\_certificate\_id](#input\_http\_certificate\_id) | Id of the HTTPS certificate in Certificate Manager | `string` | `null` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The size of bucket, in bytes (5 Gb by default). Set 0 if you do not want to limit bucket size | `number` | `5368709120` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of lockbox secret | `string` | n/a | yes |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | The secret key to use when applying changes. If omitted, storage\_secret\_key specified in provider config is used | `string` | `null` | no |
| <a name="input_server_side_encryption_kms_id"></a> [server\_side\_encryption\_kms\_id](#input\_server\_side\_encryption\_kms\_id) | n/a | `string` | `null` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Bucket storage class. Can be COLD or STANDARD | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Bucket Id |
| <a name="output_name"></a> [name](#output\_name) | Bucket name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-storage-bucket/blob/main/LICENSE).

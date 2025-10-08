# Example of creating single bucket

## Usage

To run this example you need to execute:

```bash
export YC_FOLDER_ID='folder_id'
terraform init
terraform plan
terraform apply
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_accounts"></a> [iam\_accounts](#module\_iam\_accounts) | git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account | v1.0.0 |
| <a name="module_storage_buckets"></a> [storage\_buckets](#module\_storage\_buckets) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | Access key for the storage admin |
| <a name="output_secret_key"></a> [secret\_key](#output\_secret\_key) | Secret key for the storage admin |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-storage-bucket/blob/main/LICENSE).

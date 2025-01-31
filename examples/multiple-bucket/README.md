# Example of creating multiple buckets

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
| <a name="module_storage_buckets"></a> [storage\_buckets](#module\_storage\_buckets) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Map of buckets configuration | <pre>map(object({<br/>    enabled           = bool<br/>    storage_class     = string<br/>    max_size          = number<br/>    enable_versioning = bool<br/>  }))</pre> | <pre>{<br/>  "backup": {<br/>    "enable_versioning": false,<br/>    "enabled": true,<br/>    "max_size": 5368709120,<br/>    "storage_class": "COLD"<br/>  },<br/>  "data": {<br/>    "enable_versioning": false,<br/>    "enabled": true,<br/>    "max_size": 5368709120,<br/>    "storage_class": "STANDARD"<br/>  }<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-storage-bucket/blob/main/LICENSE).

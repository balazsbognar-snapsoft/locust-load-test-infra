<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.10.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label_context"></a> [label\_context](#module\_label\_context) | ../null-label | n/a |
| <a name="module_label_iam_policy"></a> [label\_iam\_policy](#module\_label\_iam\_policy) | ../null-label | n/a |
| <a name="module_label_iam_role"></a> [label\_iam\_role](#module\_label\_iam\_role) | ../null-label | n/a |
| <a name="module_label_ro_iam_policy"></a> [label\_ro\_iam\_policy](#module\_label\_ro\_iam\_policy) | ../null-label | n/a |
| <a name="module_label_ro_iam_role"></a> [label\_ro\_iam\_role](#module\_label\_ro\_iam\_role) | ../null-label | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.ro_s3_backend_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_backend_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ro_terraform_role_terraform_s3_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.terraform_role_terraform_s3_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ro_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ro_s3_backend_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_backend_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | The common tags, which should be applied to all resources | `map(string)` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Naming context used by naming convention module | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "resource_type": null,<br/>  "stage": null,<br/>  "tags": {}<br/>}</pre> | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | A kms key which will be used to encrypt state | `string` | n/a | yes |
| <a name="input_paths"></a> [paths](#input\_paths) | A list a paths which will be allowed for access like [prod/*,global/*] | `list(string)` | n/a | yes |
| <a name="input_principals"></a> [principals](#input\_principals) | Map of service name as key and a list of ARNs as value to allow assuming the role (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`))) | `map(list(string))` | n/a | yes |
| <a name="input_s3_backend_bucket_arn"></a> [s3\_backend\_bucket\_arn](#input\_s3\_backend\_bucket\_arn) | The arn of the bucket which will be used for state management | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ro_role"></a> [ro\_role](#output\_ro\_role) | n/a |
| <a name="output_role"></a> [role](#output\_role) | n/a |
<!-- END_TF_DOCS -->
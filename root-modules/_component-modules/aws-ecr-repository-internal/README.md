<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label_aws_ecr_repository"></a> [label\_aws\_ecr\_repository](#module\_label\_aws\_ecr\_repository) | ../null-label | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.ecr_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy_document.repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | List of account IDs that will have read access to the repository. | `list(string)` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Naming context used by naming convention module | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "resource_type": null,<br/>  "stage": null,<br/>  "tags": {}<br/>}</pre> | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the repository. | `string` | n/a | yes |
| <a name="input_trusted_principle_arns"></a> [trusted\_principle\_arns](#input\_trusted\_principle\_arns) | List of IAM ARNs that will have write access to the repository. | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
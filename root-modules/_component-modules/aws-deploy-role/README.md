# aws-deploy-role

## Features

- Create Terraform deployer roles

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.10.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_policy_assumable_roles_label"></a> [iam\_policy\_assumable\_roles\_label](#module\_iam\_policy\_assumable\_roles\_label) | ../null-label | n/a |
| <a name="module_iam_role_label"></a> [iam\_role\_label](#module\_iam\_role\_label) | ../null-label | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.assumable_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.assumable_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assumeable_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assumable_role_arns"></a> [assumable\_role\_arns](#input\_assumable\_role\_arns) | The role arns which will be allowed to be assumed by the deployer | `list(string)` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Naming context used by naming convention module | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "resource_type": null,<br/>  "stage": null,<br/>  "tags": {}<br/>}</pre> | no |
| <a name="input_principals"></a> [principals](#input\_principals) | Map of service name as key and a list of ARNs as value to allow assuming the role (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`))) | `map(list(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role"></a> [role](#output\_role) | n/a |
<!-- END_TF_DOCS -->

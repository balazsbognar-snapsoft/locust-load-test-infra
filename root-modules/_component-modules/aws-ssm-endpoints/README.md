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
| <a name="module_label"></a> [label](#module\_label) | ../null-label | n/a |
| <a name="module_label_gateway_endpoint"></a> [label\_gateway\_endpoint](#module\_label\_gateway\_endpoint) | ../null-label | n/a |
| <a name="module_label_interface_endpoint"></a> [label\_interface\_endpoint](#module\_label\_interface\_endpoint) | ../null-label | n/a |
| <a name="module_label_sg"></a> [label\_sg](#module\_label\_sg) | ../null-label | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_endpoint.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_iam_policy_document.s3_gateway_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route_tables.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Id of the deploying account. | `string` | n/a | yes |
| <a name="input_add_gateway_endpoints"></a> [add\_gateway\_endpoints](#input\_add\_gateway\_endpoints) | Indicate whether VPC Gateway endpoints should be added or not. | `bool` | `false` | no |
| <a name="input_add_interface_endpoints"></a> [add\_interface\_endpoints](#input\_add\_interface\_endpoints) | Indicate whether VPC Interface endpoints should be added or not. | `bool` | `false` | no |
| <a name="input_available_interface_endpoints"></a> [available\_interface\_endpoints](#input\_available\_interface\_endpoints) | The list of interface endpoints that are already available in the VPC and should not be added. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Naming context used by naming convention module | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "resource_type": null,<br/>  "stage": null,<br/>  "tags": {}<br/>}</pre> | no |
| <a name="input_enable_ecr_s3_bucket_readonly_permission"></a> [enable\_ecr\_s3\_bucket\_readonly\_permission](#input\_enable\_ecr\_s3\_bucket\_readonly\_permission) | Amazon ECR uses Amazon S3 to store the docker image layers. If the variable is true, than the endpoint polcy will have access to the 'arn:aws:s3:::prod-region-starport-layer-bucket/*' resource | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The organization id. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where this module is deployed. | `string` | n/a | yes |
| <a name="input_s3_logging_bucket"></a> [s3\_logging\_bucket](#input\_s3\_logging\_bucket) | If add\_gateway\_endpoints is true, then configures its gateway policy to allow SSM logging required actions to this bucket. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet where the VPC endpoints should be added. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the VPC endpoints should be added. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
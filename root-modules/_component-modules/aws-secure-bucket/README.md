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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label_access_log_bucket"></a> [label\_access\_log\_bucket](#module\_label\_access\_log\_bucket) | ../null-label | n/a |
| <a name="module_label_this_bucket"></a> [label\_this\_bucket](#module\_label\_this\_bucket) | ../null-label | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.access_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.access_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.access_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.content_days](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_object_lock_configuration.content_years](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.access_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.access_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.content_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.access_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.access_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.content_aes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.content_kms_awskey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.content_kms_masterkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_iam_policy_document.access_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.content_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_content_bucket_tags"></a> [additional\_content\_bucket\_tags](#input\_additional\_content\_bucket\_tags) | Adds these tags to the content bucket only. | `map(string)` | `{}` | no |
| <a name="input_blocked_encryption_types"></a> [blocked\_encryption\_types](#input\_blocked\_encryption\_types) | List of server-side encryption types to block for object uploads. | `list(string)` | `[]` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether or not to use Amazon S3 Bucket Keys for this bucket. | `bool` | `false` | no |
| <a name="input_content_bucket_object_ownership"></a> [content\_bucket\_object\_ownership](#input\_content\_bucket\_object\_ownership) | n/a | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_content_bucket_public_access_block"></a> [content\_bucket\_public\_access\_block](#input\_content\_bucket\_public\_access\_block) | n/a | <pre>object({<br/>    block_public_acls       = bool<br/>    block_public_policy     = bool<br/>    ignore_public_acls      = bool<br/>    restrict_public_buckets = bool<br/>  })</pre> | <pre>{<br/>  "block_public_acls": true,<br/>  "block_public_policy": true,<br/>  "ignore_public_acls": true,<br/>  "restrict_public_buckets": true<br/>}</pre> | no |
| <a name="input_context"></a> [context](#input\_context) | Naming context used by naming convention module | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "resource_type": null,<br/>  "stage": null,<br/>  "tags": {}<br/>}</pre> | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | Lista a CORS szabályok definiálásához | <pre>list(object({<br/>    allowed_headers = optional(list(string))<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = optional(list(string))<br/>    max_age_seconds = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_iam_statements"></a> [custom\_iam\_statements](#input\_custom\_iam\_statements) | List of additional IAM policies for the S3 bucket policy. | <pre>list(object({<br/>    sid       = optional(string)<br/>    effect    = optional(string, "Allow")<br/>    actions   = list(string)<br/>    resources = list(string)<br/>    principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })), [])<br/>    conditions = optional(list(object({<br/>      test     = string<br/>      values   = list(string)<br/>      variable = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The AWS KMS master key ID used for the SSE-KMS encryption.<br/>This can only be used when you set the value of sse\_algorithm as aws:kms.<br/>The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms. | `string` | `null` | no |
| <a name="input_lifecycle_configuration"></a> [lifecycle\_configuration](#input\_lifecycle\_configuration) | Configure transition and expiration of log archive S3 buckets. | <pre>map(object({<br/>    abort_incomplete_multipart_upload = optional(number)<br/>    transitions = optional(map(object({<br/>      storage_class = string<br/>      days          = number<br/>    })), {})<br/>    expiration = optional(object({<br/>      days = number<br/>    }))<br/>  }))</pre> | <pre>{<br/>  "auto_archive": {<br/>    "abort_incomplete_multipart_upload": 7<br/>  }<br/>}</pre> | no |
| <a name="input_lifecycle_configuration_for_content"></a> [lifecycle\_configuration\_for\_content](#input\_lifecycle\_configuration\_for\_content) | Configure transition and expiration of content S3 buckets. | <pre>map(object({<br/>    abort_incomplete_multipart_upload = optional(number)<br/>    transitions = optional(map(object({<br/>      storage_class = string<br/>      days          = number<br/>    })), {})<br/>    noncurrent_transitions = optional(map(object({<br/>      storage_class = string<br/>      days          = number<br/>      versions      = optional(number, 0)<br/>    })), {})<br/>    expiration = optional(object({<br/>      days = number<br/>    }))<br/>    noncurrent_expiration = optional(object({<br/>      days     = number<br/>      versions = optional(number, 0)<br/>    }))<br/>    filter = optional(object({<br/>      and = optional(object({<br/>        prefix                   = optional(string)<br/>        object_size_greater_than = optional(number)<br/>        object_size_less_than    = optional(number)<br/>        tags                     = optional(map(string))<br/>      }))<br/>      object_size_greater_than = optional(number)<br/>      object_size_less_than    = optional(number)<br/>      prefix                   = optional(string, "")<br/>      tag = optional(object({<br/>        key   = string<br/>        value = string<br/>      }))<br/>    }))<br/>  }))</pre> | <pre>{<br/>  "auto_archive": {<br/>    "abort_incomplete_multipart_upload": 7<br/>  }<br/>}</pre> | no |
| <a name="input_log_prefix"></a> [log\_prefix](#input\_log\_prefix) | Key prefix for access logs | `string` | `""` | no |
| <a name="input_migration_from_old_s3_defaults"></a> [migration\_from\_old\_s3\_defaults](#input\_migration\_from\_old\_s3\_defaults) | This should be true in cases where the bucket was created with the old api<br/>because aws\_s3\_bucket\_ownership\_controls cant be imported if it was the default configuration, so if you want no-op plan<br/>you must skip the creation of this resource in those cases. | `bool` | `false` | no |
| <a name="input_object_lock_configuration"></a> [object\_lock\_configuration](#input\_object\_lock\_configuration) | Configuration block for object locking.<br/>If enabled only years or days can be passed, not both at the same time, one of them must be null.<br/>Mode can be GOVERNANCE or COMPLIANCE.<br/>COMPLIANCE objects can not be deleted anyway (bar account delete) until the days or years are passed. | <pre>object({<br/>    enabled = bool<br/>    mode    = string<br/>    years   = number<br/>    days    = number<br/><br/>  })</pre> | <pre>{<br/>  "days": null,<br/>  "enabled": false,<br/>  "mode": null,<br/>  "years": null<br/>}</pre> | no |
| <a name="input_s3_access_log_bucket_name_append_resource_name"></a> [s3\_access\_log\_bucket\_name\_append\_resource\_name](#input\_s3\_access\_log\_bucket\_name\_append\_resource\_name) | If true, the S3 access log bucket name has an 's3-bucket' postfix. | `bool` | `true` | no |
| <a name="input_s3_bucket_name_append_resource_name"></a> [s3\_bucket\_name\_append\_resource\_name](#input\_s3\_bucket\_name\_append\_resource\_name) | If true, the S3 bucket name has an 's3-bucket' postfix. | `bool` | `true` | no |
| <a name="input_s3_content_bucket_acp_grants"></a> [s3\_content\_bucket\_acp\_grants](#input\_s3\_content\_bucket\_acp\_grants) | Lista az S3 ACL grant-ek definiálásához | <pre>list(object({<br/>    permission = string<br/>    grantee = object({<br/>      type = string<br/>      uri  = optional(string)<br/>      id   = optional(string)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The algorithm which will be used for the encryption of the bucket. | `string` | n/a | yes |
| <a name="input_transition_default_minimum_object_size"></a> [transition\_default\_minimum\_object\_size](#input\_transition\_default\_minimum\_object\_size) | The default minimum object size behavior applied to the lifecycle configuration. | `string` | `"all_storage_classes_128K"` | no |
| <a name="input_use_acl_for_access_logs"></a> [use\_acl\_for\_access\_logs](#input\_use\_acl\_for\_access\_logs) | Use acl for access logs bucket permission if true and policy if false | `bool` | `false` | no |
| <a name="input_use_acl_for_content"></a> [use\_acl\_for\_content](#input\_use\_acl\_for\_content) | Use acl for content bucket permission if true and policy if false | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Versioning Enabled / Disabled | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_content_bucket"></a> [content\_bucket](#output\_content\_bucket) | This S3 bucket. |
| <a name="output_content_policy"></a> [content\_policy](#output\_content\_policy) | n/a |
| <a name="output_log_bucket"></a> [log\_bucket](#output\_log\_bucket) | The S3 bucket used for storing access logs of this bucket. |
<!-- END_TF_DOCS -->

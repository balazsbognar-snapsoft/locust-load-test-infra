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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_endpoints"></a> [endpoints](#module\_endpoints) | ../aws-ssm-endpoints | n/a |
| <a name="module_label_custom_policy"></a> [label\_custom\_policy](#module\_label\_custom\_policy) | ../null-label | n/a |
| <a name="module_label_ebs"></a> [label\_ebs](#module\_label\_ebs) | ../null-label | n/a |
| <a name="module_label_ec2_instance"></a> [label\_ec2\_instance](#module\_label\_ec2\_instance) | ../null-label | n/a |
| <a name="module_label_endpoints"></a> [label\_endpoints](#module\_label\_endpoints) | ../null-label | n/a |
| <a name="module_label_generated_policy"></a> [label\_generated\_policy](#module\_label\_generated\_policy) | ../null-label | n/a |
| <a name="module_label_instance_profile"></a> [label\_instance\_profile](#module\_label\_instance\_profile) | ../null-label | n/a |
| <a name="module_label_mac_host"></a> [label\_mac\_host](#module\_label\_mac\_host) | ../null-label | n/a |
| <a name="module_label_policy"></a> [label\_policy](#module\_label\_policy) | ../null-label | n/a |
| <a name="module_label_role"></a> [label\_role](#module\_label\_role) | ../null-label | n/a |
| <a name="module_label_sg"></a> [label\_sg](#module\_label\_sg) | ../null-label | n/a |
| <a name="module_label_ssm_attach_efs"></a> [label\_ssm\_attach\_efs](#module\_label\_ssm\_attach\_efs) | ../null-label | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_host.mac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_host) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ec2_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ec2_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ec2_http_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ec2_https_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.icmp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_association.attach_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.attach_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [null_resource.ec2_redeploy_trigger](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.amazon_linux_2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.macos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ec2_instance_type.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |
| [aws_iam_policy_document.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AL2023_version_selector"></a> [AL2023\_version\_selector](#input\_AL2023\_version\_selector) | In case of AL2023 ami usage you can define the query | `string` | `"2023.*"` | no |
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Id of the deploying account. | `string` | n/a | yes |
| <a name="input_add_gateway_endpoints"></a> [add\_gateway\_endpoints](#input\_add\_gateway\_endpoints) | Indicate whether VPC Gateway endpoints should be added or not | `bool` | `false` | no |
| <a name="input_add_interface_endpoints"></a> [add\_interface\_endpoints](#input\_add\_interface\_endpoints) | Indicate whether VPC Interface endpoints should be added or not. | `bool` | `false` | no |
| <a name="input_add_trusted_ca_cert"></a> [add\_trusted\_ca\_cert](#input\_add\_trusted\_ca\_cert) | Adds the provided PEM encoded certificate as a trusted Certificate Authority to the jumpbox OS. | `string` | `null` | no |
| <a name="input_allow_all_egress"></a> [allow\_all\_egress](#input\_allow\_all\_egress) | Indicate whether the security group of the EC2 instance should allow any egress traffic or not. | `bool` | `true` | no |
| <a name="input_allow_http"></a> [allow\_http](#input\_allow\_http) | Indicate whether the security group of the EC2 instance should allow TCP traffic on port 80 or not. | `bool` | `true` | no |
| <a name="input_allow_http_egress"></a> [allow\_http\_egress](#input\_allow\_http\_egress) | Indicate whether the security group of the EC2 instance should allow egress TCP traffic on port 80 or not. | `bool` | `false` | no |
| <a name="input_allow_https_egress"></a> [allow\_https\_egress](#input\_allow\_https\_egress) | Indicate whether the security group of the EC2 instance should allow egress TCP traffic on port 443 or not. | `bool` | `false` | no |
| <a name="input_allow_ping"></a> [allow\_ping](#input\_allow\_ping) | Indicate whether the security group of the EC2 instance should allow ping request or not. | `bool` | `true` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The ami id to be launched. If 'amazon-linux-2' is provided, then Amazon Linux 2 is used, if 'ubuntu' is provided, then an Ubuntu Server 20.04 LTS is used, if amazon-linux-2023 then lts will be selected based on jumpbox\_AL2023\_version\_selector. | `string` | `"amazon-linux-2"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Indicates if the instance should receive a public IP address. | `bool` | `false` | no |
| <a name="input_available_interface_endpoints"></a> [available\_interface\_endpoints](#input\_available\_interface\_endpoints) | The list of interface endpoints that are already available in the VPC and should not be added. | `list(string)` | `[]` | no |
| <a name="input_bitrise_token_secret_arn"></a> [bitrise\_token\_secret\_arn](#input\_bitrise\_token\_secret\_arn) | The ARN of the secret that contains the Bitrise token in case a macos instance is created. | `string` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Naming context used by naming convention module | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "resource_type": null,<br/>  "stage": null,<br/>  "tags": {}<br/>}</pre> | no |
| <a name="input_efs_mounts"></a> [efs\_mounts](#input\_efs\_mounts) | Elastic File System drives that needs to get attached to the EC2 instance. | <pre>map(object({<br/>    file_system_id  = string<br/>    access_point_id = string<br/>    mount_path      = string<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_ecr_s3_bucket_readonly_permission"></a> [enable\_ecr\_s3\_bucket\_readonly\_permission](#input\_enable\_ecr\_s3\_bucket\_readonly\_permission) | Amazon ECR uses Amazon S3 to store the docker image layers. If the variable is true, than the endpoint polcy will have access to the 'arn:aws:s3:::prod-region-starport-layer-bucket/*' resource | `bool` | `false` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | This variable can be used for modifying the hostname of the EC2 instance. If EC2\_INSTANCE\_RESOURCE\_NAME is set, then the hostname will be configured to the resource name of the EC2 instance. | `string` | `null` | no |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | Define the IAM instance profile name that will be assigned for the EC2 instance. | `string` | `null` | no |
| <a name="input_instance_custom_policies"></a> [instance\_custom\_policies](#input\_instance\_custom\_policies) | n/a | <pre>list(object({<br/>    sid       = optional(string)<br/>    effect    = optional(string, "Allow")<br/>    actions   = list(string)<br/>    resources = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_instance_keeper"></a> [instance\_keeper](#input\_instance\_keeper) | Any change to this string triggers an instance redeployment. If the provided ami\_id is 'amazon-linux-2' or 'ubuntu' then the latest image will be used. This can be used to OS patch such instances. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The EC2 instance type to be launched. | `string` | `"t3.micro"` | no |
| <a name="input_is_bitrise_runner"></a> [is\_bitrise\_runner](#input\_is\_bitrise\_runner) | Set to true if the EC2 is for a bitrise runner. | `bool` | `false` | no |
| <a name="input_macos_image_name_prefix"></a> [macos\_image\_name\_prefix](#input\_macos\_image\_name\_prefix) | The name prefix for the MacOS AMI to be used. | `string` | `"bitrise-macos-sonoma15-baremetal-stable-v2.62.1-v2-"` | no |
| <a name="input_macos_instance_type"></a> [macos\_instance\_type](#input\_macos\_instance\_type) | The instance type for mac instances. | `string` | `"mac2-m2.metal"` | no |
| <a name="input_ms_defender"></a> [ms\_defender](#input\_ms\_defender) | Microsoft defender installation parameters. | <pre>object({<br/>    dependencies = object({<br/>      s3_bucket_name          = string<br/>      s3_folder_path          = string<br/>      mde_netfilter_file_name = string<br/>      mdatp_file_name         = string<br/>      mdatp_onboard_file_name = string<br/>    })<br/>    proxy_address = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_network_tester_instance_enabled"></a> [network\_tester\_instance\_enabled](#input\_network\_tester\_instance\_enabled) | Indicates if the instance should receive the tag that is used by the network tester to indicate that this instance can be used for network testing. | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The organization id. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where this module is deployed. | `string` | n/a | yes |
| <a name="input_role_permission_configuration"></a> [role\_permission\_configuration](#input\_role\_permission\_configuration) | Configuration object for creating granular access to named resources<br/>example:<br/>  {<br/>        s3 = {<br/>            read = ["s3\_arn\_1","s3\_arn\_2"]<br/>            write = ["s3\_arn\_1","s3\_arn\_2"]<br/>          }<br/>        dynamodb-table = {<br/>          read  = [dynamodb-table\_arn\_1, dynamodb-table\_arn\_2]<br/>          write = [dynamodb-table\_arn\_1, dynamodb-table\_arn\_2]<br/>          }<br/>          rds-iam = {<br/>              auth = []<br/>          }<br/>          sqs = {<br/>            read = ["sqs\_arn\_1","sqs\_arn\_2"]<br/>            write = ["sqs\_arn\_1","sqs\_arn\_2"]<br/>          }<br/>          sns= {<br/>            read      = ["sns\_arn\_1","sns\_arn\_2"]<br/>            write     = ["sns\_arn\_1","sns\_arn\_2"]<br/>          }<br/>          sns-apf= {<br/>            read      = ["sns\_arn\_1","sns\_arn\_2"]<br/>            write     = ["sns\_arn\_1","sns\_arn\_2"]<br/>          }<br/>          secrets={<br/>          read = ["secret\_arn"]<br/>          }<br/>} | `any` | `null` | no |
| <a name="input_root_block_device_volume_size"></a> [root\_block\_device\_volume\_size](#input\_root\_block\_device\_volume\_size) | Volume size in GB of the root volume | `number` | `50` | no |
| <a name="input_root_block_device_volume_type"></a> [root\_block\_device\_volume\_type](#input\_root\_block\_device\_volume\_type) | Type of the Root block device volume | `string` | `"gp3"` | no |
| <a name="input_ssm_cloudwatch_log_group_name"></a> [ssm\_cloudwatch\_log\_group\_name](#input\_ssm\_cloudwatch\_log\_group\_name) | Attach IAM policy that allows logging to the provided log group. | `string` | `"/aws/ssm/sessions"` | no |
| <a name="input_ssm_s3_bucket_name"></a> [ssm\_s3\_bucket\_name](#input\_ssm\_s3\_bucket\_name) | Attach IAM policy that allows SSM logging to the provided S3 bucket. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The IDs of subnet to launch the EC2 instance in. | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to launch the EC2 instance in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the EC2 instance |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private ip of the jumpbox |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
| <a name="output_selected_ami"></a> [selected\_ami](#output\_selected\_ami) | The ami name that is used for the jumpbox |
<!-- END_TF_DOCS -->
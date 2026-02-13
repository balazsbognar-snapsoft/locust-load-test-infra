variable "context" {
  type = any
  default = {
    enabled             = true
    namespace           = null
    resource_type       = null
    environment         = null
    stage               = null
    name                = null
    delimiter           = null
    attributes          = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = []
    id_length_limit     = null
    label_key_case      = null
    label_value_case    = null
    descriptor_formats  = {}
    # Note: we have to use [] instead of null for unset lists due to
    # https://github.com/hashicorp/terraform/issues/28137
    # which was not fixed until Terraform 1.0.0,
    # but we want the default to be all the labels in `label_order`
    # and we want users to be able to prevent all tag generation
    # by setting `labels_as_tags` to `[]`, so we need
    # a different sentinel to indicate "default"
    labels_as_tags = ["unset"]
  }
  description = <<-EOT
    Naming context used by naming convention module
  EOT

  validation {
    condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper"], var.context["label_key_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }

  validation {
    condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], var.context["label_value_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "region" {
  description = "The region where this module is deployed."
  type        = string
}

variable "organization_id" {
  description = "The organization id."
  type        = string
}

variable "account_id" {
  type        = string
  description = "Id of the deploying account."
  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "Invalid account id."
  }
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to launch the EC2 instance in."
}

variable "subnet_id" {
  type        = string
  description = "The IDs of subnet to launch the EC2 instance in."
}

variable "ami_id" {
  type        = string
  default     = "amazon-linux-2"
  description = "The ami id to be launched. If 'amazon-linux-2' is provided, then Amazon Linux 2 is used, if 'ubuntu' is provided, then an Ubuntu Server 20.04 LTS is used, if amazon-linux-2023 then lts will be selected based on jumpbox_AL2023_version_selector."
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The EC2 instance type to be launched."
}

variable "iam_instance_profile_name" {
  type        = string
  description = "Define the IAM instance profile name that will be assigned for the EC2 instance."
  default     = null
}

variable "instance_custom_policies" {
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "instance_keeper" {
  type        = string
  default     = ""
  description = "Any change to this string triggers an instance redeployment. If the provided ami_id is 'amazon-linux-2' or 'ubuntu' then the latest image will be used. This can be used to OS patch such instances."
}

variable "allow_ping" {
  type        = bool
  default     = true
  description = "Indicate whether the security group of the EC2 instance should allow ping request or not."
}

variable "allow_http" {
  type        = bool
  default     = true
  description = "Indicate whether the security group of the EC2 instance should allow TCP traffic on port 80 or not."
}

variable "allow_http_egress" {
  type        = bool
  default     = false
  description = "Indicate whether the security group of the EC2 instance should allow egress TCP traffic on port 80 or not."
}

variable "allow_https_egress" {
  type        = bool
  default     = false
  description = "Indicate whether the security group of the EC2 instance should allow egress TCP traffic on port 443 or not."
}

variable "allow_all_egress" {
  type        = bool
  default     = true
  description = "Indicate whether the security group of the EC2 instance should allow any egress traffic or not."
}

variable "add_interface_endpoints" {
  type        = bool
  default     = false
  description = "Indicate whether VPC Interface endpoints should be added or not."
}

variable "available_interface_endpoints" {
  type        = list(string)
  default     = []
  description = "The list of interface endpoints that are already available in the VPC and should not be added."
}

variable "add_gateway_endpoints" {
  type        = bool
  default     = false
  description = "Indicate whether VPC Gateway endpoints should be added or not"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Indicates if the instance should receive a public IP address."
}

variable "network_tester_instance_enabled" {
  type        = bool
  default     = false
  description = "Indicates if the instance should receive the tag that is used by the network tester to indicate that this instance can be used for network testing."
}

variable "efs_mounts" {
  type = map(object({
    file_system_id  = string
    access_point_id = string
    mount_path      = string
  }))

  default     = {}
  description = "Elastic File System drives that needs to get attached to the EC2 instance."
}

variable "add_trusted_ca_cert" {
  type        = string
  default     = null
  description = "Adds the provided PEM encoded certificate as a trusted Certificate Authority to the jumpbox OS."
}

variable "ssm_cloudwatch_log_group_name" {
  type        = string
  default     = "/aws/ssm/sessions"
  description = "Attach IAM policy that allows logging to the provided log group."
}

variable "ssm_s3_bucket_name" {
  type        = string
  default     = null
  description = "Attach IAM policy that allows SSM logging to the provided S3 bucket."
}

variable "role_permission_configuration" {
  description = <<-EOT
    Configuration object for creating granular access to named resources
    example:
      {
            s3 = {
                read = ["s3_arn_1","s3_arn_2"]
                write = ["s3_arn_1","s3_arn_2"]
              }
            dynamodb-table = {
              read  = [dynamodb-table_arn_1, dynamodb-table_arn_2]
              write = [dynamodb-table_arn_1, dynamodb-table_arn_2]
              }
              rds-iam = {
                  auth = []
              }
              sqs = {
                read = ["sqs_arn_1","sqs_arn_2"]
                write = ["sqs_arn_1","sqs_arn_2"]
              }
              sns= {
                read      = ["sns_arn_1","sns_arn_2"]
                write     = ["sns_arn_1","sns_arn_2"]
              }
              sns-apf= {
                read      = ["sns_arn_1","sns_arn_2"]
                write     = ["sns_arn_1","sns_arn_2"]
              }
              secrets={
              read = ["secret_arn"]
              }
    }
  EOT
  type        = any
  default     = null
}

variable "ms_defender" {
  type = object({
    dependencies = object({
      s3_bucket_name          = string
      s3_folder_path          = string
      mde_netfilter_file_name = string
      mdatp_file_name         = string
      mdatp_onboard_file_name = string
    })
    proxy_address = optional(string)
  })
  default     = null
  description = "Microsoft defender installation parameters."
}

variable "hostname" {
  type        = string
  default     = null
  description = "This variable can be used for modifying the hostname of the EC2 instance. If EC2_INSTANCE_RESOURCE_NAME is set, then the hostname will be configured to the resource name of the EC2 instance."
}

variable "enable_ecr_s3_bucket_readonly_permission" {
  type        = bool
  default     = false
  description = "Amazon ECR uses Amazon S3 to store the docker image layers. If the variable is true, than the endpoint polcy will have access to the 'arn:aws:s3:::prod-region-starport-layer-bucket/*' resource"
}

variable "is_bitrise_runner" {
  type        = bool
  default     = false
  description = "Set to true if the EC2 is for a bitrise runner."
}

variable "bitrise_token_secret_arn" {
  type        = string
  default     = null
  description = "The ARN of the secret that contains the Bitrise token in case a macos instance is created."
}

variable "macos_image_name_prefix" {
  type        = string
  default     = "bitrise-macos-sonoma15-baremetal-stable-v2.62.1-v2-"
  description = "The name prefix for the MacOS AMI to be used."
}

variable "macos_instance_type" {
  type        = string
  default     = "mac2-m2.metal"
  description = "The instance type for mac instances."
}

variable "AL2023_version_selector" {
  description = "In case of AL2023 ami usage you can define the query "
  type        = string
  default     = "2023.*"
}

variable "root_block_device_volume_size" {
  type        = number
  description = "Volume size in GB of the root volume"
  default     = 50
}

variable "root_block_device_volume_type" {
  type        = string
  description = "Type of the Root block device volume"
  default     = "gp3"
}

variable "user_data" {
  type    = string
  default = null
}

variable "security_group_ingress_rules" {
  description = "Security group ingress rules to add to the security group created"
  type = map(object({
    name = optional(string)

    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(string)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(string)
  }))
  default = null
}

variable "security_group_egress_rules" {
  description = "Security group egress rules to add to the security group created"
  type = map(object({
    name = optional(string)

    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(string)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(string)
  }))
  default = null
}

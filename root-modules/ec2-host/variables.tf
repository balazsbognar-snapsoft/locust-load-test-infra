variable "region" {
  type        = string
  description = "Region where to deploy resources"
}

variable "namespace" {
  type = string
}

variable "environment" {
  type = string
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
  description = "The VPC id."
  type        = string
}

variable "subnet_id" {
  description = "The Subnet id."
  type        = string
}

variable "instance_name" {
  type        = string
  default     = ""
  description = "Name of the EC2 instance."
}


variable "instance_keeper" {
  type        = string
  default     = ""
  description = "Any change to this string triggers an instance redeployment. If the provided ami_id is 'amazon-linux-2' or 'ubuntu' then the latest image will be used. This can be used to OS patch such instances."
}

variable "user_data" {
  type    = string
  default = null
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The EC2 instance type to be launched."
}

variable "ami_id" {
  type        = string
  default     = "amazon-linux-2"
  description = "The ami id to be launched. If 'amazon-linux-2' is provided, then Amazon Linux 2 is used, if 'ubuntu' is provided, then an Ubuntu Server 20.04 LTS is used, if amazon-linux-2023 then lts will be selected based on jumpbox_AL2023_version_selector."
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

variable "root_block_device_volume_size" {
  type        = number
  description = "Volume size in GB of the root volume"
  default     = 20
}

################################################################################
# Security Group
################################################################################
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

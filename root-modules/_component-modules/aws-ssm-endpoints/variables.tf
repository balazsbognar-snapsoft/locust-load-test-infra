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
  description = "The ID of the VPC where the VPC endpoints should be added."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VPC endpoints should be added."
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
  description = "Indicate whether VPC Gateway endpoints should be added or not."
}

variable "s3_logging_bucket" {
  type        = string
  default     = null
  description = "If add_gateway_endpoints is true, then configures its gateway policy to allow SSM logging required actions to this bucket."
}

variable "enable_ecr_s3_bucket_readonly_permission" {
  type        = bool
  default     = false
  description = "Amazon ECR uses Amazon S3 to store the docker image layers. If the variable is true, than the endpoint polcy will have access to the 'arn:aws:s3:::prod-region-starport-layer-bucket/*' resource"
}
variable "key_name" {
  type        = string
  description = "The name of the KMS key."
}

variable "region" {
  type = string
}

variable "account_id" {
  type        = string
  description = "The AWS account ID."
}

variable "trusted_principle_arns" {
  type        = list(string)
  description = "A list of AWS principal ARNs that are trusted to use this key."
  default     = []
}

variable "context" {
  type        = any
  description = "The context object from the null-label module."
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
    labels_as_tags      = ["unset"]
  }
}

variable "enable_ecr_permissions" {
  type        = bool
  description = "Set to true to allow the Amazon ECR service to use this key."
  default     = false
}

variable "enable_log_permissions" {
  type        = bool
  description = "Set to true to allow AWS Logs to use this key."
  default     = false
}

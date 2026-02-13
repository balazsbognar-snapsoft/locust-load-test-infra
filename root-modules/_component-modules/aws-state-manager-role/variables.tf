variable "common_tags" {
  description = "The common tags, which should be applied to all resources"
  type        = map(string)
  default     = null
}

variable "principals" {
  type        = map(list(string))
  description = "Map of service name as key and a list of ARNs as value to allow assuming the role (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`)))"
}
variable "paths" {
  description = "A list a paths which will be allowed for access like [prod/*,global/*]"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "A kms key which will be used to encrypt state"
  type        = string
}

variable "s3_backend_bucket_arn" {
  description = "The arn of the bucket which will be used for state management"
  validation {
    condition     = trimprefix(var.s3_backend_bucket_arn, "arn:aws:s3:::") != var.s3_backend_bucket_arn
    error_message = "The s3_bucket_arn must start with 'arn:aws:s3:::'."
  }
}
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


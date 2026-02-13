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
    condition = lookup(var.context, "label_key_case", null) == null ? true : contains([
      "lower", "title", "upper"
    ], var.context["label_key_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }

  validation {
    condition = lookup(var.context, "label_value_case", null) == null ? true : contains([
      "lower", "title", "upper", "none"
    ], var.context["label_value_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "s3_bucket_name_append_resource_name" {
  description = "If true, the S3 bucket name has an 's3-bucket' postfix."
  type        = bool
  default     = true
}

variable "s3_access_log_bucket_name_append_resource_name" {
  description = "If true, the S3 access log bucket name has an 's3-bucket' postfix."
  type        = bool
  default     = true
}

variable "object_lock_configuration" {
  type = object({
    enabled = bool
    mode    = string
    years   = number
    days    = number

  })
  description = <<-EOT
    Configuration block for object locking.
    If enabled only years or days can be passed, not both at the same time, one of them must be null.
    Mode can be GOVERNANCE or COMPLIANCE.
    COMPLIANCE objects can not be deleted anyway (bar account delete) until the days or years are passed.
  EOT

  default = {
    enabled = false
    mode    = null
    years   = null
    days    = null
  }
  validation {
    condition = ((var.object_lock_configuration.years != null && var.object_lock_configuration.days == null) ||
      (var.object_lock_configuration.years == null && var.object_lock_configuration.days != null) ||
    !var.object_lock_configuration.enabled)
    error_message = "If object locking is enabled then either years or days must be provided but not both."
  }
  validation {
    condition = (var.object_lock_configuration.mode == "GOVERNANCE" ||
      var.object_lock_configuration.mode == "COMPLIANCE" ||
    !var.object_lock_configuration.enabled)
    error_message = "If object locking is enabled then mode must be either COMPLIANCE or GOVERNANCE."
  }
}

variable "lifecycle_configuration" {
  type = map(object({
    abort_incomplete_multipart_upload = optional(number)
    transitions = optional(map(object({
      storage_class = string
      days          = number
    })), {})
    expiration = optional(object({
      days = number
    }))
  }))
  default = {
    auto_archive = {
      abort_incomplete_multipart_upload = 7
    }
  }
  description = "Configure transition and expiration of log archive S3 buckets."
}

variable "lifecycle_configuration_for_content" {
  type = map(object({
    abort_incomplete_multipart_upload = optional(number)
    transitions = optional(map(object({
      storage_class = string
      days          = number
    })), {})
    noncurrent_transitions = optional(map(object({
      storage_class = string
      days          = number
      versions      = optional(number, 0)
    })), {})
    expiration = optional(object({
      days = number
    }))
    noncurrent_expiration = optional(object({
      days     = number
      versions = optional(number, 0)
    }))
    filter = optional(object({
      and = optional(object({
        prefix                   = optional(string)
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        tags                     = optional(map(string))
      }))
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      prefix                   = optional(string, "")
      tag = optional(object({
        key   = string
        value = string
      }))
    }))
  }))
  default = {
    auto_archive = {
      abort_incomplete_multipart_upload = 7
    }
  }
  description = "Configure transition and expiration of content S3 buckets."
}

variable "transition_default_minimum_object_size" {
  type        = string
  description = "The default minimum object size behavior applied to the lifecycle configuration. "
  default     = "all_storage_classes_128K"
}

variable "force_destroy" {
  description = " A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for this bucket."
  default     = false
}

variable "blocked_encryption_types" {
  description = "List of server-side encryption types to block for object uploads."
  type        = list(string)
  default     = []
}

variable "sse_algorithm" {
  type        = string
  description = "The algorithm which will be used for the encryption of the bucket."
  validation {
    condition     = var.sse_algorithm == "AES256" || var.sse_algorithm == "aws:kms"
    error_message = "The valid values are AES256 and aws:kms."
  }
}

variable "kms_master_key_id" {
  type        = string
  default     = null
  description = <<-EOT
    The AWS KMS master key ID used for the SSE-KMS encryption.
    This can only be used when you set the value of sse_algorithm as aws:kms.
    The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms.
EOT
}

variable "additional_content_bucket_tags" {
  description = "Adds these tags to the content bucket only."
  type        = map(string)
  default     = {}
}

variable "migration_from_old_s3_defaults" {
  type        = bool
  default     = false
  description = <<-EOT
  This should be true in cases where the bucket was created with the old api
  because aws_s3_bucket_ownership_controls cant be imported if it was the default configuration, so if you want no-op plan
  you must skip the creation of this resource in those cases.
EOT
}

variable "use_acl_for_access_logs" {
  description = "Use acl for access logs bucket permission if true and policy if false"
  type        = bool
  default     = false
}

variable "use_acl_for_content" {
  description = "Use acl for content bucket permission if true and policy if false"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Versioning Enabled / Disabled"
  type        = bool
  default     = true
}

variable "log_prefix" {
  description = "Key prefix for access logs"
  type        = string
  default     = ""
}

variable "content_bucket_object_ownership" {
  type    = string
  default = "BucketOwnerEnforced"
}

variable "content_bucket_public_access_block" {
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "s3_content_bucket_acp_grants" {
  description = "Lista az S3 ACL grant-ek definiálásához"
  type = list(object({
    permission = string
    grantee = object({
      type = string
      uri  = optional(string)
      id   = optional(string)
    })
  }))
  default = []
}

variable "cors_rules" {
  description = "Lista a CORS szabályok definiálásához"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "custom_iam_statements" {
  description = "List of additional IAM policies for the S3 bucket policy."
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })), [])
    conditions = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })), [])
  }))
  default = []
}

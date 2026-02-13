variable "common_tags" {
  description = "The common tags, which should be applied to all resources"
  type        = map(string)
  default     = null
}

variable "account_id" {
  type        = string
  description = "ID of the account."
  default     = null
}

variable "region" {
  description = "The region where this module is deployed."
  type        = string
}

variable "namespace" {
  type        = string
  description = "The namespace of this module."
}


variable "environment" {
  type        = string
  description = "The environment of this module."
}

variable "name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "name_prefix" {
  type    = string
  default = ""
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

variable "sse_algorithm" {
  type        = string
  description = "The algorithm which will be used for the encryption of the bucket."
  default     = "AES256"
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

variable "create_kms_key_for_s3_encryption" {
  description = "Enable to create a custom KMS key to encrypt S3."
  type        = bool
  default     = false
}

variable "kms" {
  type = object({
    key_name               = optional(string)
    trusted_principle_arns = optional(list(string), [])
  })
  default = {}
}

variable "enable_cloudfront_permissions_for_kms" {
  type        = bool
  description = "Set to true to allow the Amazon Cloudfront service to use this key."
  default     = false
}

variable "content_bucket_object_ownership" {
  description = "Key prefix for access logs"
  type        = string
  default     = "BucketOwnerEnforced"
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

variable "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for this bucket."
  default     = false
}

variable "blocked_encryption_types" {
  description = "List of server-side encryption types to block for object uploads."
  type        = list(string)
  default     = []
}

variable "s3_content_bucket_acp_grants" {
  description = "List to define grants of ACL."
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

variable "s3_content_bucket_cors_rules" {
  description = "List to define CORS rules of the content bucket"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "transition_default_minimum_object_size" {
  type        = string
  description = "The default minimum object size behavior applied to the lifecycle configuration. "
  default     = "all_storage_classes_128K"
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

data "aws_iam_policy_document" "access_log_policy" {

  statement {
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.access_log.arn,
      "${aws_s3_bucket.access_log.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
  dynamic "statement" {
    for_each = !var.use_acl_for_access_logs ? [1] : []
    content {
      sid    = "S3ServerAccessLogsPolicy"
      effect = "Allow"
      principals {
        identifiers = ["logging.s3.amazonaws.com"]
        type        = "Service"
      }
      actions   = ["s3:PutObject"]
      resources = ["arn:aws:s3:::${module.label_access_log_bucket.id}/*"]
      condition {
        test     = "ArnLike"
        values   = ["arn:aws:s3:::${module.label_this_bucket.id}"]
        variable = "aws:SourceArn"
      }
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "content" {
  bucket = aws_s3_bucket.content.id

  rule {
    object_ownership = var.content_bucket_object_ownership
  }
}

data "aws_canonical_user_id" "current" {
}

resource "aws_s3_bucket_acl" "content" {
  depends_on = [aws_s3_bucket_ownership_controls.content]
  count      = var.use_acl_for_content ? 1 : 0
  bucket     = aws_s3_bucket.content.id
  access_control_policy {
    grant {
      permission = "FULL_CONTROL"
      grantee {
        type = "CanonicalUser"
        id   = data.aws_canonical_user_id.current.id
      }
    }
    dynamic "grant" {
      for_each = var.s3_content_bucket_acp_grants

      content {
        permission = grant.value.permission

        grantee {
          type = grant.value.grantee.type
          uri  = grant.value.grantee.uri
          id   = grant.value.grantee.id
        }
      }
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}
#  this can not be imported when created by old default api https://github.com/hashicorp/terraform-provider-aws/issues/25142
resource "aws_s3_bucket_ownership_controls" "access_log" {
  count  = var.migration_from_old_s3_defaults ? 0 : var.use_acl_for_access_logs ? 1 : 0
  bucket = aws_s3_bucket.access_log.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "access_log" {
  depends_on = [aws_s3_bucket_ownership_controls.access_log]
  count      = var.use_acl_for_access_logs ? 1 : 0
  bucket     = aws_s3_bucket.access_log.id
  acl        = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_log" {
  bucket = aws_s3_bucket.access_log.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_log" {
  for_each = var.lifecycle_configuration

  bucket = aws_s3_bucket.access_log.bucket

  dynamic "rule" {
    for_each = var.lifecycle_configuration
    content {
      id     = replace(rule.key, "_", "-")
      status = "Enabled"



      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.transitions
        content {
          noncurrent_days = noncurrent_version_transition.value.days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration == null ? [] : [1]
        content {
          days = rule.value.expiration.days
          # Expired object delete markers are cleaned up automatically (Example 7 note: https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html#lifecycle-config-conceptual-ex7)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.expiration == null ? [] : [1]
        content {
          noncurrent_days = rule.value.expiration.days
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload == null ? [] : [1]
        content {
          days_after_initiation = rule.value.abort_incomplete_multipart_upload
        }
      }
    }
  }
}

resource "aws_s3_bucket" "access_log" {
  #checkov:skip=CKV_AWS_145:The bucket is using default encryption for now
  #checkov:skip=CKV_AWS_144:The bucket is not cross region replicated for now
  #checkov:skip=CKV_AWS_21: No versioning for now
  #checkov:skip=CKV_AWS_18: This is the log bucket
  bucket        = module.label_access_log_bucket.id
  force_destroy = var.force_destroy
  tags          = module.label_access_log_bucket.tags
}

resource "aws_s3_bucket_policy" "access_log_policy" {

  bucket = aws_s3_bucket.access_log.id
  policy = data.aws_iam_policy_document.access_log_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.access_log,
  ]
}

resource "aws_s3_bucket_public_access_block" "access_log" {

  bucket = aws_s3_bucket.access_log.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "content" {
  #checkov:skip=CKV_AWS_145:The bucket is using default encryption for now
  #checkov:skip=CKV_AWS_144:The bucket is not cross region replicated for now
  bucket = module.label_this_bucket.id

  force_destroy = var.force_destroy
  tags          = merge(module.label_this_bucket.tags, var.additional_content_bucket_tags)
  depends_on = [
    aws_s3_bucket_public_access_block.access_log
  ]
}
resource "aws_s3_bucket_server_side_encryption_configuration" "content_aes" {
  for_each = var.sse_algorithm == "AES256" ? { sse_algorithm = "AES256" } : {}

  bucket = aws_s3_bucket.content.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
    bucket_key_enabled       = var.bucket_key_enabled
    blocked_encryption_types = var.blocked_encryption_types
  }
}

locals {
  kms_key_id = var.kms_master_key_id != null ? { id = var.kms_master_key_id } : {}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "content_kms_awskey" {
  for_each = var.sse_algorithm == "aws:kms" && local.kms_key_id == {} ? { sse_algorithm = "aws:kms" } : {}

  bucket = aws_s3_bucket.content.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "content_kms_masterkey" {
  for_each = var.sse_algorithm == "aws:kms" && local.kms_key_id != {} ? { sse_algorithm = "aws:kms" } : {}

  bucket = aws_s3_bucket.content.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "content" {
  for_each = var.lifecycle_configuration_for_content

  bucket                                 = aws_s3_bucket.content.bucket
  transition_default_minimum_object_size = var.transition_default_minimum_object_size

  dynamic "rule" {
    for_each = var.lifecycle_configuration_for_content
    content {
      id     = replace(rule.key, "_", "-")
      status = "Enabled"

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload == null ? [] : [1]
        content {
          days_after_initiation = rule.value.abort_incomplete_multipart_upload
        }
      }

      dynamic "filter" {
        # Itt átadjuk a filter objektumot a listában, nem [1]-et
        for_each = rule.value.filter == null ? [] : [rule.value.filter]

        content {
          dynamic "and" {
            # Itt átadjuk az AND objektumot a listában
            for_each = filter.value.and == null ? [] : [filter.value.and]

            content {
              # Így már működik az and.value.prefix, mert az and.value maga az objektum
              prefix                   = and.value.prefix
              object_size_greater_than = and.value.object_size_greater_than
              object_size_less_than    = and.value.object_size_less_than
              tags                     = and.value.tags
            }
          }

          prefix                   = filter.value.prefix
          object_size_greater_than = filter.value.object_size_greater_than
          object_size_less_than    = filter.value.object_size_less_than

          dynamic "tag" {
            # Itt átadjuk a TAG objektumot a listában
            for_each = filter.value.tag == null ? [] : [filter.value.tag]

            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_transitions
        content {
          noncurrent_days           = noncurrent_version_transition.value.days
          storage_class             = noncurrent_version_transition.value.storage_class
          newer_noncurrent_versions = noncurrent_version_transition.value.versions
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration == null ? [] : [1]
        content {
          days = rule.value.expiration.days
          # Expired object delete markers are cleaned up automatically (Example 7 note: https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html#lifecycle-config-conceptual-ex7)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_expiration == null ? [] : [1]
        content {
          noncurrent_days           = rule.value.noncurrent_expiration.days
          newer_noncurrent_versions = rule.value.noncurrent_expiration.versions
        }
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "content" {

  bucket = aws_s3_bucket.content.id

  block_public_acls       = var.content_bucket_public_access_block.block_public_acls
  block_public_policy     = var.content_bucket_public_access_block.block_public_policy
  ignore_public_acls      = var.content_bucket_public_access_block.ignore_public_acls
  restrict_public_buckets = var.content_bucket_public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_object_lock_configuration" "content_days" {
  for_each = var.object_lock_configuration.enabled == true && var.object_lock_configuration.days != null ? {
    enabled : true
  } : {}

  bucket = aws_s3_bucket.content.bucket

  rule {
    default_retention {
      mode = var.object_lock_configuration.mode
      days = var.object_lock_configuration.days
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "content_years" {
  for_each = var.object_lock_configuration.enabled == true && var.object_lock_configuration.years != null ? {
    enabled : true
  } : {}

  bucket = aws_s3_bucket.content.bucket

  rule {
    default_retention {
      mode  = var.object_lock_configuration.mode
      years = var.object_lock_configuration.years
    }
  }
}

resource "aws_s3_bucket_versioning" "content" {
  bucket = aws_s3_bucket.content.bucket
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_logging" "content" {
  bucket        = aws_s3_bucket.content.bucket
  target_bucket = aws_s3_bucket.access_log.bucket
  target_prefix = var.log_prefix
}

resource "aws_s3_bucket_cors_configuration" "content" {
  count = length(var.cors_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.content.bucket

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

data "aws_iam_policy_document" "content_policy" {
  dynamic "statement" {
    for_each = var.custom_iam_statements

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

output "content_policy" {
  value = data.aws_iam_policy_document.content_policy.json
}

resource "aws_s3_bucket_policy" "content_policy" {
  count = length(data.aws_iam_policy_document.content_policy.json) > 30 ? 1 : 0

  bucket = aws_s3_bucket.content.id
  policy = data.aws_iam_policy_document.content_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.content,
  ]
}

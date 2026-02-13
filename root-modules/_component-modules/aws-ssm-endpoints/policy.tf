data "aws_iam_policy_document" "s3_gateway_policy" {
  statement {
    sid = "AccessToAmazonBuckets"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    actions = ["s3:GetObject"]
    effect  = "Allow"
    resources = compact(
      concat([
        "arn:aws:s3:::packages.${var.region}.amazonaws.com/*",
        "arn:aws:s3:::repo.${var.region}.amazonaws.com/*",
        "arn:aws:s3:::amazonlinux.${var.region}.amazonaws.com/*",
        "arn:aws:s3:::amazonlinux-2-repos-${var.region}/*"],
        var.enable_ecr_s3_bucket_readonly_permission ? ["arn:aws:s3:::prod-${var.region}-starport-layer-bucket/*"] : []
      )
    )
  }

  dynamic "statement" {
    for_each = var.s3_logging_bucket == null ? [] : [1]

    content {
      sid = "AccessToSSMLogBucketContent"
      principals {
        identifiers = ["*"]
        type        = "AWS"
      }
      actions   = ["s3:PutObject", "s3:PutObjectAcl"]
      effect    = "Allow"
      resources = ["arn:aws:s3:::${var.s3_logging_bucket}/*"]
      condition {
        test     = "StringEquals"
        values   = [var.organization_id]
        variable = "aws:PrincipalOrgID"
      }
    }
  }

  dynamic "statement" {
    for_each = var.s3_logging_bucket == null ? [] : [1]

    content {
      sid = "AccessToSSMLogBucket"
      principals {
        identifiers = ["*"]
        type        = "AWS"
      }
      actions   = ["s3:GetEncryptionConfiguration"]
      effect    = "Allow"
      resources = ["arn:aws:s3:::${var.s3_logging_bucket}"]
      condition {
        test     = "StringEquals"
        values   = [var.organization_id]
        variable = "aws:PrincipalOrgID"
      }
    }
  }

}
module "label_kms_key" {
  source = "../null-label"

  name    = var.key_name
  context = var.context
}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "Enable IAM User Permissions from this account"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.trusted_principle_arns) > 0 ? [1] : []

    content {
      sid    = "AllowCrossAccountUse"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.trusted_principle_arns
      }
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.enable_log_permissions ? [1] : []

    content {
      sid    = "AllowLogEncryption"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["logs.${var.region}.amazonaws.com"]
      }
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]

      condition {
        test     = "ArnEquals"
        variable = "kms:EncryptionContext:aws:logs:arn"
        values   = ["arn:aws:logs:${var.region}:${var.account_id}:*"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.enable_ecr_permissions ? [1] : []
    content {
      sid    = "AllowECRServiceUse"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["ecr.amazonaws.com"]
      }

      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*"
      ]
      resources = ["*"]

      condition {
        test     = "StringEquals"
        variable = "kms:CallerAccount"
        values   = [var.account_id]
      }

      condition {
        test     = "StringLike"
        variable = "kms:EncryptionContext:aws:ecr:arn"
        values   = ["arn:aws:ecr:*:${var.account_id}:repository/*"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.enable_ecr_permissions ? [1] : []
    content {
      sid    = "AllowECRServiceGrant"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["ecr.amazonaws.com"]
      }

      actions = [
        "kms:CreateGrant",
        "kms:DescribeKey"
      ]
      resources = ["*"]

      condition {
        test     = "StringEquals"
        variable = "kms:CallerAccount"
        values   = [var.account_id]
      }
    }
  }
}

resource "aws_kms_key" "this" {
  description             = "KMS Key for ${var.key_name}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json

  tags = module.label_kms_key.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${module.label_kms_key.id}"
  target_key_id = aws_kms_key.this.key_id
}

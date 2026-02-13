locals {
  assume_actions = ["sts:AssumeRole", "sts:TagSession"]
}

# Reader writer state manager role

resource "aws_iam_role" "this" {
  name               = module.label_iam_role.id
  tags               = module.label_iam_role.tags
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = local.assume_actions
    dynamic "principals" {
      for_each = var.principals
      content {
        type        = principals.key
        identifiers = tolist(principals.value)
      }
    }
  }
}

data "aws_iam_policy_document" "s3_backend_bucket_access" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      var.s3_backend_bucket_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [for p in var.paths : "${var.s3_backend_bucket_arn}/${p}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    resources = [var.kms_key_arn]
  }
}

resource "aws_iam_policy" "s3_backend_bucket_access" {
  name   = module.label_iam_policy.id
  policy = data.aws_iam_policy_document.s3_backend_bucket_access.json
  tags   = module.label_iam_policy.tags
}


resource "aws_iam_role_policy_attachment" "terraform_role_terraform_s3_bucket_access" {
  policy_arn = aws_iam_policy.s3_backend_bucket_access.arn
  role       = aws_iam_role.this.name
}

# Read-only state manager role

resource "aws_iam_role" "ro" {
  name               = module.label_ro_iam_role.id
  tags               = module.label_ro_iam_role.tags
  assume_role_policy = data.aws_iam_policy_document.ro_assume_role_policy.json
}

data "aws_iam_policy_document" "ro_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = local.assume_actions
    dynamic "principals" {
      for_each = var.principals
      content {
        type        = principals.key
        identifiers = tolist(principals.value)
      }
    }
  }
}

data "aws_iam_policy_document" "ro_s3_backend_bucket_access" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      var.s3_backend_bucket_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [for p in var.paths : "${var.s3_backend_bucket_arn}/${p}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]
    resources = [var.kms_key_arn]
  }
}

resource "aws_iam_policy" "ro_s3_backend_bucket_access" {
  name   = module.label_ro_iam_policy.id
  policy = data.aws_iam_policy_document.ro_s3_backend_bucket_access.json
  tags   = module.label_ro_iam_policy.tags
}

resource "aws_iam_role_policy_attachment" "ro_terraform_role_terraform_s3_bucket_access" {
  policy_arn = aws_iam_policy.ro_s3_backend_bucket_access.arn
  role       = aws_iam_role.ro.name
}


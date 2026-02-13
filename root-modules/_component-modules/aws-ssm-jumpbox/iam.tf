data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count              = var.iam_instance_profile_name == null ? 1 : 0
  name               = module.label_role.id
  assume_role_policy = data.aws_iam_policy_document.this.json

  tags = module.label_role.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.iam_instance_profile_name == null ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "custom" {
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"

  version = "2012-10-17"

  statement {
    sid    = "AllowCloudWatchLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:${var.ssm_cloudwatch_log_group_name}:log-stream:*",
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:${var.ssm_cloudwatch_log_group_name}"
    ]
  }

  statement {
    sid    = "AllowCloudWatchDescribe"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.ssm_s3_bucket_name == null ? [] : [0]

    content {
      sid    = "AllowS3LogBucketWrite"
      effect = "Allow"
      actions = [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
      resources = ["arn:aws:s3:::${var.ssm_s3_bucket_name}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_s3_bucket_name == null ? [] : [0]

    content {
      sid    = "AllowS3Describe"
      effect = "Allow"
      actions = [
        "s3:GetEncryptionConfiguration"
      ]
      resources = ["*"]
    }
  }
  dynamic "statement" {
    for_each = var.instance_custom_policies

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "custom" {
  count  = var.iam_instance_profile_name == null ? 1 : 0
  name   = module.label_custom_policy.id
  policy = data.aws_iam_policy_document.custom.json
  tags   = module.label_policy.tags
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = var.iam_instance_profile_name == null ? 1 : 0
  policy_arn = aws_iam_policy.custom[0].arn
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_instance_profile" "this" {
  count = var.iam_instance_profile_name == null ? 1 : 0
  name  = module.label_instance_profile.id
  role  = aws_iam_role.this[0].name

  tags = module.label_instance_profile.tags
}
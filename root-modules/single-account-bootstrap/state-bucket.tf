module "terraform_state_secure_bucket" {
  # providers               = { aws = aws.deployments } # Only enable if you want to place the tfstate bucket into a separate account
  source                  = "../_component-modules/aws-secure-bucket"
  context                 = module.label_state_bucket_s3_bucket.context
  sse_algorithm           = "aws:kms"
  kms_master_key_id       = aws_kms_key.terraform_kms.arn
  use_acl_for_access_logs = true
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_policy" "terraform_state_secure_bucket" {
  # provider = aws.deployments # Only enable if you want to place the tfstate bucket into a separate account
  bucket   = module.terraform_state_secure_bucket.content_bucket.id
  policy   = data.aws_iam_policy_document.terraform_state_secure_bucket.json
}

data "aws_iam_policy_document" "terraform_state_secure_bucket" {
  # provider  = aws.deployments # Only enable if you want to place the tfstate bucket into a separate account
  version   = "2012-10-17"
  policy_id = "Deny"
  statement {
    sid     = "EnforceSSL"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      module.terraform_state_secure_bucket.content_bucket.arn,
      "${module.terraform_state_secure_bucket.content_bucket.arn}/*"
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
}

data "aws_iam_policy_document" "state_bucket_kms" {
  # provider = aws.deployments # Only enable if you want to place the tfstate bucket into a separate account
  #checkov:skip=CKV_AWS_111: False positive kms
  #checkov:skip=CKV_AWS_109: False positive kms
  #checkov:skip=CKV_AWS_356: False positive kms
  # //https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-kms-key-policy.html
  statement {
    sid = "Enable IAM User Permissions security tooling"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.state_bucket_account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid = "Allow alias creation during setup"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.${var.region}.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [var.state_bucket_account_id]
    }
  }
}

resource "aws_kms_key" "terraform_kms" {
  # provider                = aws.deployments # Only enable if you want to place the tfstate bucket into a separate account
  description             = module.label_state_bucket_kms.id
  deletion_window_in_days = 30
  enable_key_rotation     = "true"
  policy                  = data.aws_iam_policy_document.state_bucket_kms.json
  tags                    = module.label_state_bucket_kms.tags
}

resource "aws_kms_alias" "alias_for_state_bucket_kms" {
  name          = "alias/state-bucket-kms"
  target_key_id = aws_kms_key.terraform_kms.key_id
}

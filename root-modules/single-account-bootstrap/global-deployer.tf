locals {
  default_role_name = "OrganizationAccountAccessRole"
}

data "aws_iam_policy_document" "terraform_management_role" {
  #checkov:skip=CKV_AWS_111: False positive this is the minimal we need to manage from terraform
  #checkov:skip=CKV_AWS_356: False positive this is the minimal we need to manage from terraform
  version = "2012-10-17"
  statement {
    sid    = "IAMRoleManagementPermissions"
    effect = "Allow"
    actions = [
      "iam:UpdateAssumeRolePolicy",
      "iam:GetPolicyVersion",
      "iam:ListRoleTags",
      "iam:UntagRole",
      "iam:PutRolePermissionsBoundary",
      "iam:TagRole",
      "iam:DeletePolicy",
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DetachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListPolicyTags",
      "iam:ListRolePolicies",
      "iam:CreatePolicyVersion",
      "iam:GetRole",
      "iam:GetPolicy",
      "iam:DeleteRole",
      "iam:UpdateRoleDescription",
      "iam:TagPolicy",
      "iam:CreatePolicy",
      "iam:CreateServiceLinkedRole",
      "iam:ListPolicyVersions",
      "iam:UntagPolicy",
      "iam:UpdateRole",
      "iam:DeleteServiceLinkedRole",
      "iam:GetRolePolicy",
      "iam:DeletePolicyVersion",
      "iam:ListInstanceProfilesForRole"
    ]
    resources = [
      "arn:aws:iam::${var.management_account_id}:policy/*",
      "arn:aws:iam::${var.management_account_id}:role/*"
    ]
  }

  statement {
    sid    = "IAMRoleManagementListPermissions"
    effect = "Allow"
    actions = [
      "iam:ListPolicies",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "AssumeStateManagerRolePermissions"
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]
    resources = [
      "arn:aws:iam::${var.management_account_id}:role/${module.label_global_state_manager.id}",
      "arn:aws:iam::${var.management_account_id}:role/${module.label_global_ro_state_manager.id}",
      "arn:aws:iam::${var.management_account_id}:role/${local.default_role_name}",
    ]
  }
}

# KMS and S3 permissions for the global deployer to manage the state bucket, access log bucket, and KMS key
data "aws_iam_policy_document" "terraform_global_deployer_state_bucket_kms" {
  version = "2012-10-17"
  statement {
    sid    = "KMSStateBucket"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "arn:aws:kms:${var.region}:${var.management_account_id}:alias/state-bucket-kms",
      "arn:aws:kms:${var.region}:${var.management_account_id}:key/*"
    ]
  }
  statement {
    sid    = "AllowListKMSAliases"
    effect = "Allow"
    actions = [
      "kms:ListAliases",
      "kms:ListKeys"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "S3ListAllMyBuckets"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "S3StateBucketAndAccessLog"
    effect = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.namespace}-global-terraform-state*",
      "arn:aws:s3:::${var.namespace}-global-terraform-state*/*"
    ]
  }
}

resource "aws_iam_policy" "terraform_global_deployer_state_bucket_kms" {
  name     = module.label_global_deployer_state_bucket_policy.id
  policy   = data.aws_iam_policy_document.terraform_global_deployer_state_bucket_kms.json
  tags     = module.label_global_deployer_state_bucket_policy.tags
}

resource "aws_iam_policy" "terraform_global_deployer_role_policy" {
  name     = module.label_global_deployer_role_policy.id
  policy   = data.aws_iam_policy_document.terraform_management_role.json
  tags     = module.label_global_deployer_role_policy.tags
}

resource "aws_iam_role_policy_attachment" "terraform_global_deployer_role" {
  policy_arn = aws_iam_policy.terraform_global_deployer_role_policy.arn
  role       = aws_iam_role.terraform_global_deployer_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_global_deployer_state_bucket_kms" {
  policy_arn = aws_iam_policy.terraform_global_deployer_state_bucket_kms.arn
  role       = aws_iam_role.terraform_global_deployer_role.name
}

data "aws_iam_policy_document" "terraform_global_role_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type = "AWS"
      identifiers = compact([
        var.initial_deployer_iam_user_name != "" ? "arn:aws:iam::${var.management_account_id}:user/${var.initial_deployer_iam_user_name}" : "" # TODO: remove after moving to github actions
      ])
    }
  }
}

resource "aws_iam_role" "terraform_global_deployer_role" {
  name               = module.label_global_deployer_role.id
  assume_role_policy = data.aws_iam_policy_document.terraform_global_role_assume_role_policy.json
  tags               = module.label_global_deployer_role.tags
}

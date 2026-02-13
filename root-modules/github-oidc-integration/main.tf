
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

  tags = module.label_github_oidc_provider.tags
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repo in var.allowed_github_repositories : "repo:${repo}:*"]
    }
  }
}

data "aws_iam_policy_document" "ecr_login" {
  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}
resource "aws_iam_role" "github_actions_role" {
  name               = module.label_github_actions_role.id
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = module.label_github_actions_role.tags
}

resource "aws_iam_role_policy" "ecr_login" {
  name   = "ecr-login"
  role   = aws_iam_role.github_actions_role.id
  policy = data.aws_iam_policy_document.ecr_login.json
}

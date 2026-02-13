locals {
  assume_actions = ["sts:AssumeRole", "sts:TagSession"]
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
module "iam_role_label" {
  source        = "../null-label"
  context       = var.context
  resource_type = "iam-role"
}
resource "aws_iam_role" "this" {
  name               = module.iam_role_label.id
  tags               = module.iam_role_label.tags
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assumeable_roles" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = var.assumable_role_arns
  }
}
module "iam_policy_assumable_roles_label" {
  source        = "../null-label"
  context       = var.context
  resource_type = "iam-policy"
}
resource "aws_iam_policy" "assumable_roles" {
  name   = module.iam_policy_assumable_roles_label.id
  policy = data.aws_iam_policy_document.assumeable_roles.json
}
resource "aws_iam_role_policy_attachment" "assumable_roles" {
  policy_arn = aws_iam_policy.assumable_roles.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_user" "terraform-deployer-user" {
  name = "terraform-deployer-user"
}

data "aws_iam_policy_document" "terraform-deployer-user-policy" {
  statement {
    sid = "AssumeDeployerRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.management_account_id}:role/${module.label_global_deployer_role.id}"]
  }
}

resource "aws_iam_user_policy" "terraform-deployer-user-policy" {
  name = "terraform-deployer-user-policy"
  user = aws_iam_user.terraform-deployer-user.name
  policy = data.aws_iam_policy_document.terraform-deployer-user-policy.json
}

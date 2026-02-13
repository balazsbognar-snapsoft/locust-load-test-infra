# This role allows the management deployer role to manage workload resources
# (network, databases, etc.) in the management account.
# It serves a similar purpose to OrganizationAccountAccessRole in child accounts.

resource "aws_iam_role" "management_workload_access_role" {
  name               = module.label_management_workload_access_role.id
  assume_role_policy = data.aws_iam_policy_document.management_workload_access_assume_role.json
  tags               = module.label_management_workload_access_role.tags
}

data "aws_iam_policy_document" "management_workload_access_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.management_account_id}:role/${module.terraform_management_deployer_role.role.name}"
      ]
    }
  }
}

# Attach AdministratorAccess to allow full management of workload resources
# This mirrors the OrganizationAccountAccessRole permissions in child accounts
resource "aws_iam_role_policy_attachment" "management_workload_access_admin" {
  role       = aws_iam_role.management_workload_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
